
    # Add method to ruby class String
    # ###############################
    class String
      def comment?
        self[0]=='#'
        # self[0]==35 # check if first char is #
      end
      def to_code
        s= self.dup
        s.downcase.strip.gsub(' ','_').gsub(/[^#_\/a-zA-Z0-9]/,'')
      end
    end
