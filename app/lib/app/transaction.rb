
require "dry/transaction"

module App
  Transaction = Dry::Transaction(container: App::Container)
end
