import os

exec = "C:/Users/Lenovo/AppData/Roaming/youku/upgrade/7.5.1.3200/nplayer"

source = "F:/Youku Files/download/鸿观 2015"

target = "F:/Youku Files/aac"


def getFileList(path):
    for root, dirs, files in os.walk(path):
        for f in files:
            if f.endswith(".kux"):
                s = source + "/" + f
                t = target + "/" + f.replace(".kux", ".aac")
                ex = exec + "/ffmpeg -i \"" + s + "\" -c:a copy -vn \"" + t + "\""
                print(ex, end="\n")
                os.system(ex)


getFileList(source)
