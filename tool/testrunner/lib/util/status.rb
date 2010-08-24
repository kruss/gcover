# status types

class Status
  
  UNDEFINED=1
  SUCCEED=2
  ERROR=3
  
  def Status::getString(status)
  
    case status
    when SUCCEED
      return "SUCCEED"
    when ERROR
      return "ERROR"
    else
      return "UNDEFINED"
    end
  end
  
  def Status::getHtml(status)
  
    case status
    when SUCCEED
      return "<font color=green>SUCCEED</font>"
    when ERROR
      return "<font color=red>ERROR</font>"
    else
      return "<font color=gray>UNDEFINED</font>"
    end
  end

end