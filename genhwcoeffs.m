%    HW filter formatter
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

function genhwcoeffs(cfile, hfile, fn)
  [Hd, name, Fs, pbfs, sbfs] = eval(fn);

  ficonv(Hd, "normal");
  cf = coeffs(Hd).Numerator;
  cmt = name;
  gencoeffs_q(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs, Hd.NumFracLength);
  % ficonv(Hd, "scale");
  % cf = coeffs(Hd).Numerator;
  % cmt = name + "\n(scaled version)";
  % gencoeffs_q(cfile, hfile, "scale_" + fn, cmt, cf, Fs, pbfs, sbfs, Hd.NumFracLength);
end

function gencoeffs_q(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs, bits)
  len = (length(cf) - 1) / 2 + 1;
  sts = genfilterstats(cf, 1, Fs, pbfs, sbfs);
  fprintf(hfile, gencomment(cmt + "\n\n" + sts));
  fprintf(hfile, "#define COEFFS_%s (const pct_1q15_t[%d]){ \\\n\t", upper(fn), len);
  for i = 1:len
    fprintf(hfile, "% 6d, ", cf(i) * 2^bits);
    if ((mod(i, 8) == 0) & (i ~= len))
      fprintf(hfile, " \\\n\t");
    end
  end
  fprintf(hfile, " \\\n}\n\n");
end
