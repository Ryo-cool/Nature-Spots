module Constants
  if Rails.env == "production"
    URL = "https://www.nature-spots-api.work"
  else
    URL = "http://localhost:3000/"
  end
end