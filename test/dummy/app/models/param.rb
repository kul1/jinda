class Param
  include Mongoid::Document

  validates_uniqueness_of :code
  # jinda begin
  include Mongoid::Timestamps

  field :code, :type => String
  field :pid, :type => String
  field :yearly, :type => Boolean
  field :description, :type => String
  # jinda end

  def self.get(code)
    p= where(:code=> code).first
    p.pid
  end

  def self.set(code, pid)
    p     = where(:code=> code).first
    p.pid = pid.to_s
    p.save
  end

  def self.gen(code)
    p   = where(:code=> code).first
    p ||= create! :code => code, :pid => "0", :yearly => false, :description => "auto"
    if p.yearly
      num, year = p.pid.split("/")
      y_now     = Time.now.year.to_i(-1957)
      p.pid     = if year.to_i==y_now
                    "#{num.to_i+1}/#{y_now}"
                  else # new year, restart counter
                    "1/#{y_now}"
                  end
    else
      p.pid = (p.pid.to_i+1).to_s
    end
    p.save
    p.pid
  end
end
