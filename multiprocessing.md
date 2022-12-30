# Multiprocessing

## Nice equations

### Computing speedup
```
S(n, p) = t_serial(n) / t_parallel(n, p)
...

S(n,p) = (t_serial(n) + t_operations_that_can_be_parallelized)) / (t_serial(n) + t_operations_that_can_be_parallelized(n) / p + communication(n, p))
```

### Computing efficency

```
E(n,p) = t_serial(n) / (p * t_parallel(n, p)
E(n,p) = S(n,p) / p
```
linear speedup: `0 <= E(n,p) <= 1`
above-linear-speedup: E(n,p) > 1

### Computation price

```
P(n,p) = p * t_parallel(n) = (p * t_serial(n)) / S(n,p) = t_serial(n) / E(n,p)
```

### Amdhals law
```
S(n,p) <= 1 / (f  + (1-f)/p)

f-> the code that cannot be parallelized
```

## Pthreads

### Address space

```
[code       ]
[init data  ]
[uninit data]
[heap       ]
[    |      ]
[    .      ]
[   free    ]
[    .      ]
[    |      ]
[stack  (T1)]
[stack  (T2)]
    ...
[stack  (Tn)]
[args + env ]
```

* Every thread has its own stack, stack pointer (SP), and program counter(PC)


### Example

Creates N structs, each thread processes it and returns it. No locks or anything fancy like that, just an example how 
somebody would start with pthreads in c.
```c
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

typedef struct {
    int x;
    int y;
} thread_data;

void *thread_func(void *arg) {
    thread_data *data = (thread_data *)arg; // cast arguments to correct type

    printf("thread id = %lu\n", pthread_self()); // Get unique thread id, type: pthread_t
    
    // Perform complex operations here
    printf("x = %d, y = %d\n", data->x, data->y);
    data->x += 10;
    data->y += 10;
    //
    
    //return NULL; // if you do not need to return anything
    pthread_exit((void *)data);
}

int main(int argc, char *argv[]) {
    
    if (argc != 2) {
        printf("Usage: %s <nthreads>", argv[0]);
        exit(1);
    }

    int nthreads = atoi(argv[1]);
    pthread_t threads[nthreads];
    thread_data data[nthreads];
    thread_data *ret_data[nthreads];

    for (int i = 0; i < nthreads; i++) {
        data[i].x = i;
        data[i].y = i + 1;
        pthread_create(&threads[i], NULL, thread_func, (void *)&data[i]); // Creaate thread with arguments
    } // If main thread is killed, then all the
      // threads are also killed
    
    for (int i = 0; i < nthreads; i++) {
        pthread_join(threads[i], (void **)&ret_data[i]); // Wait for every thread to finish
        printf("x = %d, y = %d\n", ret_data[i]->x, ret_data[i]->y);
    }

    return 0;
}
```


### Few properties:

* Memory is shared between the threads (basically heap is shared)
* Global variables are seen by every thread
* Communication between threads is therefore through global variables, or pointers to same structures


### Synchronization of access to same variables
* We want to limit acces to some variable, that all the threads are accessing, so that only single one will be addressed ( avoiding race condition )
* We solve this problem by using p_thread_mutexes or in other words **locks** and introduce a "critical section"
* So one threads reveserves execution of that part of the code for itself, and prevents  other threads from accessing that part of the code
* When lock is released then the next thread can continue with execution of that part of the code
* **locks** are created using atomic asm instructions (eg. test-and-set, fetch-and-add, compare-and-swap), that way a thread can lock part of a code using single instruction, preventing other threads from interrupting this behaivour.

### Deadlock

```bash
        T1                                  T2
pthread_mutex_lock_(&m1)            pthread_mutex_lock_(&m2)
pthread_mutex_lock_(&m2)            pthread_mutex_lock_(&m1)
...

pthread_mutex_unlock(&m2)           pthread_mutex_unlock(&m1)
pthread_mutex_unlock(&m1)           pthread_mutex_unlock(&m2)
```
T1 locks m1, Before it locks m2, thread T2 locks m2, T2 is now waiting for m1 to 
be unclocked, but the T1 wound release it until m2 is not free --> DEADLOCK.

### Semaphore
A counting semaphore is a generalization of a binary semaphore that can have a maximum value greater than 1. 
It is used to control access to a common resource that can be shared by multiple threads. 
When a thread wants to use the resource, it decrements the value of the semaphore. 
If the semaphore's value is greater than 0, the thread can proceed. 
If the semaphore's value is 0, the thread is blocked until the semaphore is incremented by another thread. 
When the thread is finished using the resource, it increments the semaphore's value to allow other threads to use the resource.

```c
int sem_init(sem_t * semaphore_p, int shared,unsigned initial_value);
int sem_wait(sem_t * semaphore_p);      // called on enter of critical section
                                        // if value in sem > 0:
                                        //   -> decrease value in sem
                                        //   -> continue execution
                                        // else:
                                        //   -> wait for value in sem to be > 0
int sem_post(sem_t *semaphore_p)        // This is called on exit of critical section, it incrememts the semaphore value by one 
int sem_destroy(sem_t * semaphore_p);   // destroy the semaphore
```

### Conditional variables
A conditional variable has the following operations:
*`pthread_cond_wait`: This function causes the calling thread to block until the specified condition is met. The thread must hold the mutex lock when calling this function, and it will be released while the thread is blocked. When the function returns, the mutex lock is reacquired by the thread.
*`pthread_cond_signal`: This function unblocks one thread that is blocked on the specified condition variable. If no threads are blocked on the condition variable, the function has no effect.
*`pthread_cond_broadcast`: This function unblocks all threads that are blocked on the specified condition variable. If no threads are blocked on the condition variable, the function has no effect.

example:
```c
#include <pthread.h>

pthread_mutex_t mutex;
pthread_cond_t cond;
int shared_data = 0;

void *thread_func(void *arg)
{
    pthread_mutex_lock(&mutex);
    while (shared_data == 0) {
        pthread_cond_wait(&cond, &mutex);
    }
    printf("shared_data is now %d\n", shared_data);
    pthread_mutex_unlock(&mutex);
    return NULL;
}

int main(int argc, char *argv[])
{
    pthread_t thread;
    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&cond, NULL);
    pthread_create(&thread, NULL, thread_func, NULL);
    sleep(1);
    pthread_mutex_lock(&mutex);
    shared_data = 42;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);
    pthread_join(thread, NULL);
    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&cond);
    return 0;
}
```
In this example, the main thread creates a new thread and then waits for 1 second before setting the value of shared_data to 42 
and signaling the condition variable. The new thread blocks on the condition variable until it is signaled, at which point it wakes up, 
acquires the mutex lock, and prints the value of shared_data.

#### Implementation of semaphore using conditional variables and mutexes 

```c
typedef struct {
    int value;
    pthread_cond_t cond;
    pthread_mutex_t lock;
} Sem_t;

void Sem_init(Sem_t *s, int value) {
    s->value = value;
    pthread_cond_init(&s->cond, NULL);
    pthread_mutex_init(&s->lock, NULL);
}

void Sem_wait(Sem_t *s) {
    pthread_mutex_lock(&s->lock);
    while(s->value <= 0)
        pthread_cond_wait(&s-> cond, &s-> lock); // unlocks the &s->lock and waits for signal 
    s->value--;
    pthread_mutex_unlock(&s-> lock);
}


void Sem_post(Sem_t *s) {
    pthread_mutex_lock(&s->lock);
    s->value++;

    pthread_cond_signal(&s->cond);
    pthread_mutex_unlock(&s->lock);
}
```

### Barrier

A point in code, where all the threads wait for eachother.

Implementation using conditional  vars:

```c
//pthread_mutex_init(&lock, NULL);
//pthread_cond_init(&condition, NULL);
void* barrier(void* arg) 
{
	int i;
	int myid = (int)arg;	

	for(i=0; i<NPRINTS; i++)
	{
		if( myid == 0 )
			shared++;

		// barrirer -> start 
		pthread_mutex_lock(&lock);
		threads++;
		if( threads < NTHREADS )
			while( pthread_cond_wait(&condition, &lock) != 0 );
		else
		{
			threads = 0; // when the last thread arrives, broadast the signal to other threads to continue execution
			pthread_cond_broadcast(&condition);
		}
		pthread_mutex_unlock(&lock);
		// barrier -> end 

		printf("Nit %d: vrednost: %d\n", myid, shared);
	}

	return NULL;
}
// pthread_mutex_destroy(&lock);
// pthread_cond_destroy(&condition);
```


```c
// pthread_barrier_t b;
// pthread_barrier_init( &b, NULL, NTHREADS );

void* barrier(void* arg) 
{
	int i;
	int myid = (int)arg;

	for(i=0; i<NPRINTS; i++)
	{
		if( myid == 0 )
			shared++;

		pthread_barrier_wait( &b );
		printf("%d %d\n", myid, shared );
	}

	return NULL;
}
// pthread_barrier_destroy( &b );
```

## Models of parallelization

- **Manager / worker**
    - Manager:
        - Dynamically spawns worker on need
        - Workers should be independent of eachother
    - Worker:
        - Processes data passed by the Manager
        - Saves the result or returns it to the Manager
cons: dynamic creation of threads and not using the thread pool (large cost of creating new threads and destroying them)
solution: use thread pool

- **Equaly weighted threads**
    - Main thread spawns all the threads
    - All the threads are working concurrently and are weighted equaly
    - Each thread may be doing some different
    - Usually there is a lot of communication and waits between threads, which can lead to performance decreases 

- **Pipeline**
    - Thread 0 takes care for the inputs and passes it to threads
    - Thread N takes care of the output
    - Threads are exchanig work
    - Every thread uses resources if needed
    - Pipeline speed is determined by the slowest stage 
    - Each stage can spawn multiple threads if needed
