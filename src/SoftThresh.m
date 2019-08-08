function [ xhat ] = SoftThresh(y, lambda)
% SoftThresh Soft Threshold y at value lambda
% Source code from T2 Shuffling Toolbox
% "T2 Shuffling: Sharp, Multi-Contrast, Volumetric Fast Spin-Echo Imaging"
% https://github.com/jtamir/t2shuffling-support/
%
% University of California Educational/Research License:
% Copyright (c) 2015-2016. The Regents of the University of California (Regents).
% All Rights Reserved. Permission to use, copy, modify, and distribute this
% software and its documentation for educational, research, and not-for-profit
% purposes, without fee and without a signed licensing agreement, is hereby
% granted, provided that the above copyright notice, this paragraph and the
% following two paragraphs appear in all copies, modifications, and distributions.
% Contact The Office of Technology Licensing, UC Berkeley, 2150 Shattuck Avenue,
% Suite 510, Berkeley, CA 94720-1620, (510) 643-7201, for commercial licensing
% opportunities.
% Created by Jonathan Tamir <jtamir@eecs.berkeley.edu>.
% Department of Electrical Engineering and Computer Sciences,
% University of California, Berkeley.
% IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS BEEN
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

xhat = y.*(abs(y) - lambda)./abs(y);
xhat(abs(y) <= lambda) = 0;

end
