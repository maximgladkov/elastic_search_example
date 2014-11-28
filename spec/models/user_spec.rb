require 'rails_helper'

RSpec.describe User, :type => :model do

  def create_user(aux_data)
    User.new.tap do |user|
      user.aux_data = aux_data
      user.save!
    end
  end

  let!(:user_with_string)         { create_user(birthday: 'august') }
  let!(:user_with_boolean)        { create_user(birthday: true) }
  let!(:user_with_date_in_past)   { create_user(birthday: Date.new(2013, 10, 1)) }
  let!(:user_with_date_in_future) { create_user(birthday: Date.new(2016, 10, 1)) }

  before(:each) {
    User.import
  }

  context 'for string search' do
    it 'returns user with string only' do
      users = User.search('august').records.to_a
      expect(users).to eq([ user_with_string ])
    end
  end

  context 'for date search' do
    it 'returns user with date in the past' do
      users = User.search(query: { filtered: { filter: { range: { birthday_datetime: { lte: "now" } } } } }).records.to_a
      expect(users).to eq([ user_with_date_in_past ])
    end

    it 'returns user with date in the future' do
      users = User.search(query: { filtered: { filter: { range: { birthday_datetime: { gte: "now" } } } } }).records.to_a
      expect(users).to eq([ user_with_date_in_future ])
    end
  end

  context 'for boolean search' do
    it 'returns user with boolean' do
      users = User.search(query: { filtered: { filter: { term: { birthday_boolean: true } } } }).records.to_a
      expect(users).to eq([ user_with_boolean ])
    end
  end

end
