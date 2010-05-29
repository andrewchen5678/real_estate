module OrderScope
  def self.included(base)
    base.instance_eval do
      named_scope :ordered, lambda {|*args|
        retorder=args.first || 'created_at DESC'
        if(args.length>1 && args[1])
          retorder+=' DESC'
        end
        { :order => retorder}
      }
    end
  end
end
