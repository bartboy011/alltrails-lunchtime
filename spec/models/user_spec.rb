require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should reject creation without password' do
    expect { User.create! email: 'test' }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should reject creation without email' do
    expect { User.create! password: 'test' }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should be created with email and password' do
    user = User.create! email: 'test', password: 'test'
    expect(user.save)
  end
end
