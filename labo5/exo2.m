clc; clear all; close all;

tf1 = zpk([-0.4], [-10, -2.4, 0, 0], [0.0595])

nyquist(tf1)

tf2 = tf(0.0595*[1, 0.4], [1, 12.4, 12.4, 0, 0])

figure
nyquist(tf2)
