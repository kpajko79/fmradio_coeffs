%    Differentiator filter statistics
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

function txt = gendiffstats(Num, Fs, pbf)
  pbf = pbf * 2 * pi / Fs;
  r = linspace(pi/8192, pi, 8191); % skip the 0
  r = unique([r pbf], "sorted"); % add the frequencies of interest
  mag = abs(freqz(Num, 1, r));
  gain = mag ./ r;
  sysgain = max(gain);
  ovr = length(find(gain > 1)) * 100 / length(gain);
  fsysmax = r(find(gain == sysgain)) * Fs / (2 * pi);

  txt = sprintf("System gain = %.18f (%+.5f dB), Maximum at %.4f Hz (%.4f%%%% is over unity)", ...
                sysgain, 20 * log10(sysgain), fsysmax, ovr);

  x = find(r == pbf);
  pb = gain(1:x);

  [pbmin, pbmax] = bounds(pb);
  pbavg = mean(pb);
  pbstd = std(pb);
  pbmed = median(pb);
  pbmad = median(abs(pb - pbmed));

  fpbmax = r(find(gain == pbmax)) * Fs / (2 * pi);
  fpbmin = r(find(gain == pbmin)) * Fs / (2 * pi);

  txt = txt + sprintf("\\n\\nPassband gain = %.10f .. %.10f (%+.5f .. %+.5f dB)", ...
                      pbmin, pbmax, 20 * log10(pbmin), 20 * log10(pbmax));
  txt = txt + sprintf("\\nMinimum at %.4f Hz, Maximum at %.4f Hz", ...
                      fpbmin, fpbmax);
  txt = txt + sprintf("\\nMedian = %.10f (%+.5f dB) Mean = %.10f (%+.5f dB)", ...
                      pbmed, 20 * log10(pbmed), ...
                      pbavg, 20 * log10(pbavg));
  txt = txt + sprintf("\\nMAD = %.10f STD = %.10f", ...
                      pbmad, pbstd);
end
