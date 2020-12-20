f = 4000;
fs = 4 *f;
delta_t = 1/fs;
t = -0.01:delta_t:0.01;
m_t = sinc(f*t);
n = length(m_t);
plot(t,m_t);
m_f = fft(m_t)/2;
freqaxis = linspace(-1*fs,fs,n);
plot(freqaxis,fftshift(abs(m_f)));
figure(2)
plot(t,m_t);
d = 50;
c_t = dirac(t)/(d*d);
idx = c_t == Inf; % find Inf
c_t(idx) = 1;     % set Inf to finite value 
figure(3)
plot(t,c_t);

mc_t = m_t.*c_t;
mc_f = fft(mc_t);
figure(4)
plot(t,mc_t);
figure(5)
plot(freqaxis,fftshift(abs(mc_f)));