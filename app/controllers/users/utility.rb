Struct.new("Error", :message, :style)
def check_error(param)
  if @user.errors.include?(param) 
    return Struct::Error.new("*"+@user.errors.full_messages_for(param)[0], " has-error")
  else 
    return Struct::Error.new("", "")
  end
end

def modify_email()
  position = @user.email.index( "@" )
  if position != nil
    @user.email= @user.email[0..position-1]
  end
end