module.exports = (req, res, next)->
  if req.isAuthenticated() then return next()
  res.redirect '/login'
