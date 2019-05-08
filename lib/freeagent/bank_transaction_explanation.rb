module FreeAgent
  class BankTransactionExplanation < Resource
    resource :bank_transaction_explanation

    resource_methods :find, :filter 

    attr_accessor :bank_account, :bank_transaction, :dated_on, :manual_sales_tax_amount, :description, :gross_value
    attr_accessor :foreign_currency_value, :rebill_type, :rebill_factor, :category, :attachment

    decimal_accessor :gross_value

    date_accessor :dated_on

    def self.find_all_by_bank_account(bank_account, options = {})
      options.merge!(bank_account: bank_account)
      BankTransactionExplanation.filter(options) 
    end

    def self.find(transaction, options = {})
      options.merge!(transaction: transaction)
      BankTransactionExplanation.filter(options) 
    end

    def self.create_for_transaction(bank_transaction, date, description, value, category, options = {})
      FreeAgent.client.post "bank_transaction_explanations",
      {
        bank_transaction_explanation: 
        {
          bank_transaction: bank_transaction,
          dated_on: date,
          description: description,
          gross_value: value,
          category: category
        }
      }
    end

    def self.create_for_account(bank_account, date, description, value, category, options = {})
      FreeAgent.client.post "bank_transaction_explanations",
      {
        bank_transaction_explanation: 
        {
          bank_account: bank_account,
          dated_on: date,
          description: description,
          gross_value: value,
          category: category
        }
      }
    end

    def self.create_transfer(bank_transaction, date, value, transfer_account)
      FreeAgent.client.post "bank_transaction_explanations",
      {
        bank_transaction_explanation: 
        {
          bank_transaction: bank_transaction,
          dated_on: date,
          gross_value: value,
          transfer_bank_account: "#{FreeAgent::Client.site}bank_accounts/#{transfer_account}"
        }
      }
    end
  end
end