import 'dart:async';
import 'dart:js' as js;

class AudioHelper {
  static bool _initialized = false;

  static void _init() {
    if (_initialized) return;
    try {
      js.context.callMethod('eval', [r'''
        window.cyberAudio = {
          ctx: null,
          init() {
            if (this.ctx) return;
            const AudioContextClass = window.AudioContext || window.webkitAudioContext;
            if (AudioContextClass) {
              this.ctx = new AudioContextClass();
            }
          },
          playTone(freq, type, duration, vol = 0.03) {
            this.init();
            if (!this.ctx) return;
            if (this.ctx.state === 'suspended') {
              this.ctx.resume();
            }
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();
            osc.type = type;
            osc.frequency.setValueAtTime(freq, this.ctx.currentTime);
            
            gain.gain.setValueAtTime(vol, this.ctx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.0001, this.ctx.currentTime + duration);
            
            osc.connect(gain);
            gain.connect(this.ctx.destination);
            
            osc.start();
            osc.stop(this.ctx.currentTime + duration);
          },
          playSweep(freqStart, freqEnd, type, duration, vol = 0.03) {
            this.init();
            if (!this.ctx) return;
            if (this.ctx.state === 'suspended') {
              this.ctx.resume();
            }
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();
            osc.type = type;
            osc.frequency.setValueAtTime(freqStart, this.ctx.currentTime);
            osc.frequency.exponentialRampToValueAtTime(freqEnd, this.ctx.currentTime + duration);
            
            gain.gain.setValueAtTime(vol, this.ctx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.0001, this.ctx.currentTime + duration);
            
            osc.connect(gain);
            gain.connect(this.ctx.destination);
            
            osc.start();
            osc.stop(this.ctx.currentTime + duration);
          }
        };
      ''']);
      _initialized = true;
    } catch (e) {
      // Fail silently on non-supported platforms
    }
  }

  static void playHover() {
    _init();
    try {
      js.context['cyberAudio'].callMethod('playTone', [880, 'triangle', 0.05, 0.02]);
    } catch (_) {}
  }

  static void playClick() {
    _init();
    try {
      js.context['cyberAudio'].callMethod('playSweep', [700, 200, 'sine', 0.1, 0.04]);
    } catch (_) {}
  }

  static void playKey() {
    _init();
    try {
      js.context['cyberAudio'].callMethod('playTone', [1100, 'sine', 0.015, 0.015]);
    } catch (_) {}
  }

  static void playSuccess() {
    _init();
    try {
      js.context['cyberAudio'].callMethod('playTone', [523.25, 'sine', 0.12, 0.02]); // C5
      Future.delayed(const Duration(milliseconds: 50), () {
        js.context['cyberAudio'].callMethod('playTone', [659.25, 'sine', 0.12, 0.02]); // E5
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        js.context['cyberAudio'].callMethod('playTone', [783.99, 'sine', 0.12, 0.02]); // G5
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        js.context['cyberAudio'].callMethod('playTone', [1046.50, 'sine', 0.25, 0.03]); // C6
      });
    } catch (_) {}
  }
}
