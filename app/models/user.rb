class User < ActiveRecord::Base

  validates :name, :email, presence: true, uniqueness: true
  validates :email, format: {with: /(\A[a-z]+\@vinsol\.[a-z]{2,3}\Z)/i}
  has_secure_password
  after_destroy :ensure_an_admin_remains
  before_destroy :check_for_admin
  before_update :check_for_admin

  private

  def check_for_admin
    raise "Can't Delete/Update Admin" if self.email.eq?('admin@depot.com')
  end

  def ensure_an_admin_remains
    if User.count.zero?
      raise "Can't delete last user"
    end
  end

end
