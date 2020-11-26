
    def freemind2action(s)
      case s.downcase
        #when 'bookmark' # Excellent
        #  'call'
      when 'bookmark' # Excellent
        'do'
      when 'attach' # Look here
        'form'
      when 'edit' # Refine
        'pdf'
      when 'wizard' # Magic
        'ws'
      when 'help' # Question
        'if'
      when 'forward' # Forward
        # 'redirect'
        'direct_to'
      when 'kaddressbook' #Phone
        'invoke' # invoke new service along the way
      when 'idea' # output
        'output'
      when 'list' # List
        'list'
      when 'folder' # Folder
        'folder'
      when 'mail'
        'mail'
      # when 'xmag' # Tobe discussed
      when 'To be discusssed'
        'search'  
      end
    end
