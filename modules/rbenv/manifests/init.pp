class rbenv {
  include rbenv::install
  include rbenv::ruby-build

     Class['rbenv::install']
  -> Class['rbenv::ruby-build']
}
