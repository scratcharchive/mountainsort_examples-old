#!/bin/sh

mls-run ./synthesize_dataset.ml --results=datasets/synth_K10 --parameters K:10 samplerate:30000 duration:600 M:8
mls-run ./synthesize_dataset.ml --results=datasets/synth_K20 --parameters K:20 samplerate:30000 duration:600 M:8
mls-run ./synthesize_dataset.ml --results=datasets/synth_K40 --parameters K:40 samplerate:30000 duration:600 M:8
