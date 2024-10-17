# FFMPEG

## Converting .mp3 into .wav

```bash
ffmpeg -i file.mp3 newfile.wav
```

## Cutting audio/video

```bash
ffmpeg -i f24122a7f35de434d996.ogg -ss 00:00:00 -to 00:00:30 -c copy mini.ogg
```


## Creating video from sequence of images

```bash
ffmpeg -framerate 30 -i "some_image_%04d.jpg" -c:v libx264 -pix_fmt yuv420p output_video.mp4
```

### Create vertically stacked video of multiple videos


```bash
ffmpeg -i video1.mp4 -i video2.mp4 -i video3.mp4 -filter_complex "[0:v][1:v][2:v]vstack=inputs=3" output.mp4
```

### Cut out the section of the video

Cut from the 10s 30seconds of the video.

```bash
ffmpeg -ss 00:00:10 -i input_video.mp4 -t 30 -c:v libx264 -c:a aac -strict experimental output_video.mp4
```
