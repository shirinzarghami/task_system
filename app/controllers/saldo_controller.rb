class SaldoController < ApplicationController
  before_filter :find_community

  def show
    @community.members.map {|user| }  

    ActiveRecord::Base.connection.select_all("
      SELECT SUM(user_saldo_modifications.price) AS sum_user_saldo_modifications_price, user_id AS user_id
      FROM `user_saldo_modifications` 
        INNER JOIN `payments` ON `payments`.`id` = `user_saldo_modifications`.`payment_id` 
        RIGHT OUTER JOIN community_users ON community_users.id = payments.community_user_id
        WHERE (community_users.community_id = 1) 
        GROUP BY user_id
      ")

    UserSaldoModification.joins(:payment).joins('RIGHT OUTER JOIN community_users ON community_users.id = payments.community_user_id').where(['community_users.community_id = ?', c.id]).group(:user_id)

  end
end
