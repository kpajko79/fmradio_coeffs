%    Antialiasing filter parameter generator
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

function [F, A, W] = genaa(Fsin, Fsout, Fstop)

F = [ 0 Fstop ];
A = [ 1 1 ];
W = [ 1 ];

if (Fstop > Fsout/2)
  error("The stop frequency is greater than the half of the output sample rate.");
elseif (Fstop == Fsout/2) || (Fsout - Fstop) >= Fsin/2
  [F, A, W] = addrange(F, A, W, Fstop + 0.0001, Fsin/2, 1);
else
  i = 1;
  top = 0;
  while top < Fsin/2
    w = 1;
    bot = i * Fsout - Fstop;
    top = i * Fsout + Fstop;

    if (bot >= Fsin/2)
      bot = (i - 1) * Fsout + Fstop + 1;
      w = 0.0001;
    end

    if (top > Fsin/2)
      top = Fsin/2;
    end

    [F, A, W] = addrange(F, A, W, bot, top, w);

    i = i + 1;
  end
end
end

function [F, A, W] = addrange(F, A, W, bot, top, w)
  F(end+1:end+2) = [bot top];
  A(end+1:end+2) = [0 0];
  W(end+1) = [w];
end

% [EOF]
