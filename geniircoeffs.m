%    IIR filter formatter
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

function geniircoeffs(cfile, hfile, fn)
  [Hd, name, Fs, pbfs, sbfs] = eval(fn);

  set(Hd, 'Arithmetic', 'single');
  cf = coeffs(Hd);
  cmt = name;
  gencoeffs_f(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs);
  ficonv(Hd, "normal");
  cf = coeffs(Hd);
  cmt = name;
  gencoeffs_q(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs, Hd.NumFracLength);
end

function gencoeffs_f(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs)
  sts = genfilterstats(cf.Numerator, cf.Denominator, Fs, pbfs, sbfs);
  fprintf(hfile, gencomment(cmt + "\n\n" + sts));
  fprintf(hfile, "float %s_f[5];\n\n", fn);
  fprintf(cfile, "float %s_f[5] = { % .10ff, % .10ff, % .10ff, % .10ff, % .10ff, };\n\n", fn, ...
      cf.Numerator(1), ...
      cf.Numerator(2), ...
      cf.Numerator(3), ...
      cf.Denominator(2), ...
      cf.Denominator(3));
end

function gencoeffs_q(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs, bits)
  Num = cf.Numerator .* 2^bits;
  Den = cf.Denominator .* 2^bits;
  sts = genfilterstats(cf.Numerator, cf.Denominator, Fs, pbfs, sbfs);
  fprintf(hfile, gencomment(cmt + "\n\n" + sts));
  fprintf(hfile, "pct_1q15_t %s[6];\n\n", fn);
  fprintf(cfile, "pct_1q15_t %s[6] = { % 6d, % 6d, % 6d, % 6d, % 6d, % 6d, };\n\n", fn, ...
      Num(1), ...
      0, ...
      Num(2), ...
      Num(3), ...
      Den(2), ...
      Den(3));
end
