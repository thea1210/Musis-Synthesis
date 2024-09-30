function yy = clarinet(f0, Aenv, Ienv, dur, fsamp)

tt = 1/fsamp:1/fsamp:dur;
fc = 1*f0;
fm = 3*f0;

Aenv = interp1(linspace(0, dur, length(Aenv)), Aenv, tt, 'linear', 'extrap');
Ienv = interp1(linspace(0, dur, length(Ienv)), Ienv, tt, 'linear', 'extrap');

yy = Aenv .* cos((2*pi*fc) .* tt + (Ienv .* cos((2*pi*fm) .* tt)));
end

