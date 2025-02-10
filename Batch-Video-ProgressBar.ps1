/* ****** VARIABLES ****** */

$barcolor="green"
$ffmpegPath="C:\Downloads\ffmpeg-7.1-essentials_build\bin"

/* ****** VARIABLES ****** */

foreach ($video in Get-ChildItem -Recurse -Filter *.mp4) {
    $duration = & "$ffmpegPath\ffprobe.exe" -hide_banner -loglevel quiet -show_entries format=duration -print_format default=nokey=1:noprint_wrappers=1 $video.FullName
    $width = & "$ffmpegPath\ffprobe.exe" -hide_banner -loglevel quiet -select_streams v:0 -show_entries stream=width -print_format default=nokey=1:noprint_wrappers=1 $video.FullName
    $framerate = & "$ffmpegPath\ffprobe.exe" -hide_banner -loglevel quiet -select_streams v:0 -show_entries stream=avg_frame_rate -print_format default=nokey=1:noprint_wrappers=1 $video.FullName
    $codec = & "$ffmpegPath\ffprobe.exe" -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 $video.FullName
    $bitrate = & "$ffmpegPath\ffprobe.exe" -v error -select_streams v:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 $video.FullName

    $output = Join-Path $video.Directory.FullName ("withBar-" + $video.Name)

    & "$ffmpegPath\ffmpeg.exe" -i $video.FullName -filter_complex "color=color=$($barcolor):size=$($width)x$([math]::Round($width / 100)):rate=$($framerate)[PROGRESS];[0][PROGRESS]overlay=-w+(w/$($duration))*t:H-$([math]::Round($width / 100)):shortest=1" -c:v $codec -b:v $bitrate -c:a copy $output

}
