# OxfordHack 2016 Project: Computer Control using the Muse Headband

Team: **we use muse**

Members: Andrei Barsan, Andrej Hoos, Pavel Kalvoda

For this project, we experimented leveraging the Muse Headband, which tracks
a user's brain activity using real-time EEG measurements.

We performed a statistical analysis of different activities (relaxing,
listening to music, versus being actively focused on a task such as text
editing). We built a visualization dashboard to track a user's focus, but the
classifier still needs more tuning before being useful in practice.

In a separate application, we also leveraged the device's accelerometer to
allow users to interact with the computer using head movements (by translating
head movements to mouse movements). This currently
works quite well. The code for this application resides in the `mouse/`
directory, and only supports OS X at the moment.

The raw data should be saved in the `recordings/` folder (child of the project
root). The data we collected at the hackathon is contained in the
`recordings.7z`, which is a 7zip archive. Its quality is not great, since the
recordings were performed in a relatively noisy and distracting environment,
but there is *some* signal in them. The 'baseline' recordings involve random
internet browsing. The 'relax' and 'relaxed' ones, attempts at meditation.
'forward', 'left', 'right' involve focusing on moving in that direction (they
don't seem to carry much relevant signal). 'helicopter' involves focusing on
thinking about a helicopter. As you can probably imagine, there is basically no
signal in this particular case, since the device has quite limited accuracy.
The 'typingtest' files are recordings of me focusing on a typing speed test,
while listening to music.

Please use `muse2csv.sh` to convert the raw data to `csv`, which can then be
imported in the `pymuse/nb/EEG-Analysis.ipynb` Jupyter notebook for analysis.
