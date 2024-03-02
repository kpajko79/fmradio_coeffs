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

function txt = genfilterstats(Num, Den, Fs, pbfs, sbfs)
  if find(pbfs < 0) | find(sbfs < 0)
    r = linspace(-pi, pi, 2 * 8192 - 1);
  else
    r = linspace(0, pi, 8192);
  end

  pbfs = pbfs * 2 * pi / Fs;
  sbfs = sbfs * 2 * pi / Fs;
  r = unique([r 0 pbfs sbfs], "sorted"); % add the frequencies of interest
  mag = abs(freqz(Num, Den, r));
  sysgain = max(mag);
  ovr = length(find(mag > 1)) * 100 / length(mag);
  fsysmax = r(find(mag == sysgain)) * Fs / (2 * pi);

  txt = sprintf("System gain = %.18f (%+.5f dB), Maximum at %.4f Hz (%.4f%%%% is over unity)", ...
                sysgain, 20 * log10(sysgain), fsysmax, ovr);

  pb = [];
  for i = 1 : length(pbfs) / 2
    pbs = find(r == pbfs(2 * i - 1));
    pbe = find(r == pbfs(2 * i));
    pb(end + 1 : end + 1 + pbe - pbs) = mag(pbs:pbe);
  end

  [pbmin, pbmax] = bounds(pb);
  pbavg = mean(pb);
  pbstd = std(pb);
  pbmed = median(pb);
  pbmad = median(abs(pb - pbmed));

  fpbmax = r(find(mag == pbmax)) * Fs / (2 * pi);
  fpbmin = r(find(mag == pbmin)) * Fs / (2 * pi);

  txt = txt + sprintf("\\n\\nPassband gain = %.10f .. %.10f (%+.5f .. %+.5f dB)", ...
                      pbmin, pbmax, 20 * log10(pbmin), 20 * log10(pbmax));
  txt = txt + sprintf("\\nMinimum at %.4f Hz, Maximum at %.4f Hz", ...
                      fpbmin, fpbmax);
  txt = txt + sprintf("\\nMedian = %.10f (%+.5f dB) Mean = %.10f (%+.5f dB)", ...
                      pbmed, 20 * log10(pbmed), ...
                      pbavg, 20 * log10(pbavg));
  txt = txt + sprintf("\\nMAD = %.10f STD = %.10f", ...
                      pbmad, pbstd);

  sb = [];
  for i = 1 : length(sbfs) / 2
    sbs = find(r == sbfs(2 * i - 1));
    sbe = find(r == sbfs(2 * i));
    sb(end + 1 : end + 1 + sbe - sbs) = mag(sbs:sbe);
  end

  if length(sbfs)
    [sbmin, sbmax] = bounds(sb);
    sbavg = mean(sb);
    sbstd = std(sb);
    sbmed = median(sb);
    sbmad = median(abs(sb - sbmed));

    fsbmax = r(find(mag == sbmax)) * Fs / (2 * pi);
    fsbmin = r(find(mag == sbmin)) * Fs / (2 * pi);

    txt = txt + sprintf("\\n\\nStopband atten = %.10f .. %.10f (%+.5f .. %+.5f dB)", ...
                        sbmax, sbmin, 20 * log10(sbmax), 20 * log10(sbmin));
    txt = txt + sprintf("\\nMinimum at %.4f Hz, Maximum at %.4f Hz", ...
                        fsbmax, fsbmin);
    txt = txt + sprintf("\\nMedian = %.10f (%+.5f dB) Mean = %.10f (%+.5f dB)", ...
                        sbmed, 20 * log10(sbmed), ...
                        sbavg, 20 * log10(sbavg));
    txt = txt + sprintf("\\nMAD = %.10f STD = %.10f", ...
                        sbmad, sbstd);
  end
end
