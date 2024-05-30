(
Task(
	{
		s.reboot;
		o = Server.default.options;
		o.outDevice_("Blackhole 2ch");
		o.memSize_(2.pow(21));
		s.latency_(0.5);
		s.waitForBoot(
			{
				//timer
				~timer = LinkClock.new(2);

				//some helpful arrays
				a = Array.fill(16,{arg i; i});
				b = Array.fill(16,{arg i; i});
				c = Array.fill(16,{arg i; i});
				x = Array.fill(16,{arg i; i});
				y = Array.fill(32,{arg i; i});
				z = Array.fill(16,{arg i; i});

				//samples go here! Change PathName to point to your own folder(s) of samples
				//TIP: you can drag and drop a folder right into this window, and its pathname will show up where you drop it
				d = Dictionary.new;
				d.add(\l ->
					PathName(thisProcess.nowExecutingPath.dirname++"/samples/808/").entries.collect({
						arg sf;
						Buffer.read(s, sf.fullPath);
					});
				);

				//sampler
				Task({
					SynthDef(\PlayBufPlayer, {
						arg out=0,
						bufnum=0,
						rate=1,
						start=0,
						end=1,
						t_trig=0,
						loops=1,
						amp=0.2,
						pan=0,
						rateSlew=0.1,
						panSlew=1,
						bus=0;
						var snd,
						snd2,
						pos,
						pos2,
						frames,
						duration,
						env,
						sig,
						startA,
						endA,
						startB,
						endB,
						crossfade,
						aOrB;
						aOrB=ToggleFF.kr(t_trig);
						startA=Latch.kr(start,aOrB);
						endA=Latch.kr(end,aOrB);
						startB=Latch.kr(start,1-aOrB);
						endB=Latch.kr(end,1-aOrB);
						crossfade=Lag.ar(K2A.ar(aOrB),0.1);
						rate=Lag.kr(rate,rateSlew)*BufRateScale.kr(bufnum);
						frames=BufFrames.kr(bufnum);
						duration=frames*(end-start)/rate.abs/s.sampleRate*loops;
						env=EnvGen.ar(
							Env.new(
								levels: [0,amp,amp,0],
								times: [0,duration-0.1,0.1],
							),
							gate:t_trig,
						);
						pos=Phasor.ar(
							trig:aOrB,
							rate:rate,
							start:(((rate>0)*startA)+((rate<0)*endA))*frames,
							end:(((rate>0)*endA)+((rate<0)*startA))*frames,
							resetPos:(((rate>0)*startA)+((rate<0)*endA))*frames,
						);
						snd=BufRd.ar(
							numChannels:2,
							bufnum:bufnum,
							phase:pos,
							interpolation:4,
						);
						pos2=Phasor.ar(
							trig:(1-aOrB),
							rate:rate,
							start:(((rate>0)*startB)+((rate<0)*endB))*frames,
							end:(((rate>0)*endB)+((rate<0)*startB))*frames,
							resetPos:(((rate>0)*startB)+((rate<0)*endB))*frames,
						);
						snd2=BufRd.ar(
							numChannels:2,
							bufnum:bufnum,
							phase:pos2,
							interpolation:4,
						);
						sig=Pan2.ar(
							MoogFF.ar(
								in:(crossfade*snd)+((1-crossfade)*snd2)*env,
								freq:\cutoff.kr(12000),
								gain:\resonance.kr(1)),
							pan
						);
						Out.ar(bus,sig)
					}).play(s,[\out,0]);
				}).play;
				s.sync;
				16.do(
					{
						arg i;
						x.put(i,Synth(\PlayBufPlayer,[\bufnum,d[\l][i]]));
					}
				);
				s.sync;

				//amp sequences
				a.put(0, PatternProxy(Pseq([1,0.5,0.5,1],inf)).asStream);
				a.put(1, PatternProxy(Pseq([0.75],inf)).asStream);
				a.put(2, PatternProxy(Pseq([1],inf)).asStream);
				a.put(3, PatternProxy(Pseq([1,0.25,0.25],inf)).asStream);
				a.put(4, PatternProxy(Pseq([0.25],inf)).asStream);
				a.put(5, PatternProxy(Pseq([0.1],inf)).asStream);
				a.put(6, PatternProxy(Pseq([1],inf)).asStream);
				a.put(7, PatternProxy(Pseq([1],inf)).asStream);
				a.put(8, PatternProxy(Pseq([1],inf)).asStream);
				a.put(9, PatternProxy(Pseq([1],inf)).asStream);
				a.put(10, PatternProxy(Pseq([1],inf)).asStream);
				a.put(11, PatternProxy(Pseq([1],inf)).asStream);
				a.put(12, PatternProxy(Pseq([1],inf)).asStream);
				a.put(13, PatternProxy(Pseq([1],inf)).asStream);
				a.put(14, PatternProxy(Pseq([1],inf)).asStream);
				a.put(15, PatternProxy(Pseq([1],inf)).asStream);

				//yield sequences
				y.put(0, PatternProxy(Pseq([1,1/3,2/3],inf)).asStream);
				y.put(1, PatternProxy(Pseq([1/4],inf)).asStream);
				y.put(2, PatternProxy(Pseq([1],inf)).asStream);
				y.put(3, PatternProxy(Pseq([1/12,1/12,5/6],inf)).asStream);
				y.put(4, PatternProxy(Pseq([1/3,1/3,1/3,3],inf)).asStream);
				y.put(5, PatternProxy(Pseq([1],inf)).asStream);
				y.put(6, PatternProxy(Pseq([1],inf)).asStream);
				y.put(7, PatternProxy(Pseq([1],inf)).asStream);
				y.put(8, PatternProxy(Pseq([1/4,1.75],inf)).asStream);
				y.put(9, PatternProxy(Pseq([1],inf)).asStream);
				y.put(10, PatternProxy(Pseq([1],inf)).asStream);
				y.put(11, PatternProxy(Pseq([1],inf)).asStream);
				y.put(12, PatternProxy(Pseq([1],inf)).asStream);
				y.put(13, PatternProxy(Pseq([1],inf)).asStream);
				y.put(14, PatternProxy(Pseq([1],inf)).asStream);
				y.put(15, PatternProxy(Pseq([1,1/3,2/3],inf)).asStream);
				y.put(16, PatternProxy(Pseq([1/4],inf)).asStream);
				y.put(17, PatternProxy(Pseq([1/4],inf)).asStream);
				y.put(18, PatternProxy(Pseq([1/12,1/12,5/6],inf)).asStream);
				y.put(19, PatternProxy(Pseq([1/3,1/3,1/3,3],inf)).asStream);
				y.put(20, PatternProxy(Pseq([1],inf)).asStream);
				y.put(21, PatternProxy(Pseq([1],inf)).asStream);
				y.put(22, PatternProxy(Pseq([1],inf)).asStream);
				y.put(23, PatternProxy(Pseq([1],inf)).asStream);
				y.put(24, PatternProxy(Pseq([1],inf)).asStream);
				y.put(25, PatternProxy(Pseq([1],inf)).asStream);
				y.put(26, PatternProxy(Pseq([1],inf)).asStream);
				y.put(27, PatternProxy(Pseq([1],inf)).asStream);
				y.put(28, PatternProxy(Pseq([1],inf)).asStream);
				y.put(29, PatternProxy(Pseq([1],inf)).asStream);
				y.put(30, PatternProxy(Pseq([1],inf)).asStream);
				y.put(31, PatternProxy(Pseq([1],inf)).asStream);

				//start position sequences
				b.put(0, PatternProxy(Pseq([0],inf)).asStream);
				b.put(1, PatternProxy(Pseq([0],inf)).asStream);
				b.put(2, PatternProxy(Pseq([0],inf)).asStream);
				b.put(3, PatternProxy(Pseq([0],inf)).asStream);
				b.put(4, PatternProxy(Pseq([0],inf)).asStream);
				b.put(5, PatternProxy(Pseq([0],inf)).asStream);
				b.put(6, PatternProxy(Pseq([0],inf)).asStream);
				b.put(7, PatternProxy(Pseq([0],inf)).asStream);
				b.put(8, PatternProxy(Pseq([0],inf)).asStream);
				b.put(9, PatternProxy(Pseq([0],inf)).asStream);
				b.put(10, PatternProxy(Pseq([0],inf)).asStream);
				b.put(11, PatternProxy(Pseq([0],inf)).asStream);
				b.put(12, PatternProxy(Pseq([0],inf)).asStream);
				b.put(13, PatternProxy(Pseq([0],inf)).asStream);
				b.put(14, PatternProxy(Pseq([0],inf)).asStream);
				b.put(15, PatternProxy(Pseq([0],inf)).asStream);

				//end position sequences
				z.put(0, PatternProxy(Pseq([1],inf)).asStream);
				z.put(1, PatternProxy(Pseq([1],inf)).asStream);
				z.put(2, PatternProxy(Pseq([1],inf)).asStream);
				z.put(3, PatternProxy(Pseq([1],inf)).asStream);
				z.put(4, PatternProxy(Pseq([1],inf)).asStream);
				z.put(5, PatternProxy(Pseq([1],inf)).asStream);
				z.put(6, PatternProxy(Pseq([1],inf)).asStream);
				z.put(7, PatternProxy(Pseq([1],inf)).asStream);
				z.put(8, PatternProxy(Pseq([1],inf)).asStream);
				z.put(9, PatternProxy(Pseq([1],inf)).asStream);
				z.put(10, PatternProxy(Pseq([1],inf)).asStream);
				z.put(11, PatternProxy(Pseq([1],inf)).asStream);
				z.put(12, PatternProxy(Pseq([1],inf)).asStream);
				z.put(13, PatternProxy(Pseq([1],inf)).asStream);
				z.put(14, PatternProxy(Pseq([1],inf)).asStream);
				z.put(15, PatternProxy(Pseq([1],inf)).asStream);

				//rate sequences
				c.put(0, PatternProxy(Pseq([1],inf)).asStream);
				c.put(1, PatternProxy(Prand([3/8,4/10,1/2,2/3,3/4,4/5,1,5/4,4/3,3/2,2/1,10/4,8/3,6/2],inf)).asStream);
				c.put(2, PatternProxy(Pseq([1],inf)).asStream);
				c.put(3, PatternProxy(Pseq([1],inf)).asStream);
				c.put(4, PatternProxy(Prand([3/8,4/10,1/2,2/3,3/4,4/5,1,5/4,4/3,3/2,2/1,10/4],inf)).asStream);
				c.put(5, PatternProxy(Pseq([1],inf)).asStream);
				c.put(6, PatternProxy(Pseq([1],inf)).asStream);
				c.put(7, PatternProxy(Pseq([1],inf)).asStream);
				c.put(8, PatternProxy(Pseq([1],inf)).asStream);
				c.put(9, PatternProxy(Pseq([1],inf)).asStream);
				c.put(10, PatternProxy(Pseq([1],inf)).asStream);
				c.put(11, PatternProxy(Pseq([1],inf)).asStream);
				c.put(12, PatternProxy(Pseq([1],inf)).asStream);
				c.put(13, PatternProxy(Pseq([1],inf)).asStream);
				c.put(14, PatternProxy(Pseq([1],inf)).asStream);
				c.put(15, PatternProxy(Pseq([1],inf)).asStream);

				16.do(
					{
						arg i;
						Tdef(
							i.asSymbol,
							{
								var delta,starter,ender,amp;
								loop {
									delta = y[i].next;
									starter = b[i].next;
									ender = z[i].next;
									amp = a[i].next;
									x[i].set(\t_trig,1,\start,starter,\end,ender,\loops,1,\amp,amp);
									delta.yield;
								}
							}
						).clock_(~timer).quant_(4);
						Tdef(
							(i+16).asSymbol,
							{
								var delta,rate;
								loop {
									delta = y[i+16].next;
									rate = c[i].next;
									x[i].set(\rate,rate);
									delta.yield;
								}
							}
						).clock_(~timer).quant_(4);
					}
				);
			}
		)
	}
).play(AppClock)
)

//play some tasks here
//Tdef(\1).play;

//emergency brakes
//32.do({arg i; Tdef(i.asSymbol).stop});