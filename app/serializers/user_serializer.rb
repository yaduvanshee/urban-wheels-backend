class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :wallet_balance, :type
end
