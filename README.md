# OxfordHack 2016 Project: Computer Control using the Muse Headband

Team: **potato**

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

The raw data should be saved in the 'recordings/' folder (child of the project
root). The data used during the hackathon for data exploration are not included
since they take up roughly 0.5Gb.
