# animated label
class GifAnimatedLabel < TkLabel

  def initialize(*args)
    super(*args)
    @timer = TkTimer.new{ _animation_callback }
    @timer.loop_exec = -1
    @destroy_image = false
    # bind('Destroy'){ @timer.stop }
    @btag = TkBindTag.new('Destroy'){
      @timer.stop
    }
    self.bindtags_unshift(@btag)
  end

  def start(interval)
    @timer.set_interval(interval)
    @timer.start
  end

  def stop
    @timer.stop
  end
  
    def _animation_callback()
    img = self.image
    fmt = img.format
    if fmt.kind_of?(Array)
      if fmt[1].kind_of?(Hash)
        # fmt == ['GIF', {'index'=>idx}]
        idx = fmt[1]['index']
      else
        # fmt == ['GIF', '-index', idx]  :: Ruby1.8.2 returns this.
        idx = fmt[2]
      end
    elsif fmt.kind_of?(String) && fmt =~ /GIF -index (\d+)/
      idx = $1.to_i
    else
      idx = -1
    end

    begin
      img.format("GIF -index #{idx + 1}")
    rescue => e
      img.format("GIF -index 0")
    end
  end
  private :_animation_callback
end
