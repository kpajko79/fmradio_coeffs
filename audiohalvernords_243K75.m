%    Lowpass filter generator for audio decimator
%    Copyright (C) 2024  Patrik Kluba <kpajko79@gmail.com>
%
%    Permission is hereby granted, free of charge, to any person obtaining a copy
%    of this software and associated documentation files (the "Software"), to deal
%    in the Software without restriction, including without limitation the rights
%    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%    copies of the Software, and to permit persons to whom the Software is
%    furnished to do so, subject to the following conditions:
%
%    The above copyright notice and this permission notice shall be included in all
%    copies or substantial portions of the Software.
%
%    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%    SOFTWARE.
%
%    SPDX-License-Identifier: MIT

function [Hd, name, Fs, pbfs, sbfs] = audiohalvernords_243K75

Fs    = 243750;
Fsout = 121875; % Fs/2

N    = 60;
CEMs = {'c', 'w'};
dens = 20;

[F, A, W] = genaa(Fs, Fsout, 53000);

b  = fircband(N, F/(Fs/2), A, W, CEMs, {dens});
b  = b / 1.00167469776327400;
Hd = dfilt.dffir(b);

name = sprintf("Antialias filter for %.3f -> %.3f Ksps decimation for baseband halving", Fs/1000, Fsout/1000);
[pbfs, sbfs] = genbandranges(F, A);

% [EOF]
