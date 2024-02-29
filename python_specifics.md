# PYTHON SPECIFICS

### \*args and \*\*kwargs

[reference](https://www.geeksforgeeks.org/args-kwargs-python/)

#### args

```python
def myFun(*argv):
    for arg in argv:
        print(arg)


myFun('Hello', 'Welcome', 'to', 'GeeksforGeeks')
```

```bash
Hello
Welcome
to
GeeksforGeeks
```

#### kwargs

They are basically named args in dict

```python

def myFun(**kwargs):
    for key, value in kwargs.items():
        print("%s == %s" % (key, value))


# Driver code
myFun(first='Geeks', mid='for', last='Geeks')
```

```
first == Geeks
mid == for
last == Geeks
```
