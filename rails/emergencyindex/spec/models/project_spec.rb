require 'rails_helper'

RSpec.describe Project, type: :model do

  it 'has a working factory' do
    expect(FactoryBot.create(:project)).to be_valid
  end

  describe 'description validation' do

    let(:project) { FactoryBot.create(:project) }

    it 'should accept less than 400 words' do
      project.description = File.read("#{Rails.root}/spec/fixtures/300_words.txt")
      expect(project.save).to be_truthy
    end

    it 'should reject more than 400 words' do 
      project.description = File.read("#{Rails.root}/spec/fixtures/401_words.txt")
      expect(project.save).to be_falsey
    end
  end

  describe 'image dimension validation' do

    let(:project) { FactoryBot.create(:project) }

    it 'should accept a landscape 5x7 tif' do
      project.attachment = File.open("#{Rails.root}/spec/fixtures/landscape_5x7.tif")
      expect(project.save).to be_truthy
    end

    it 'should accept a landscape 5x7 jpg' do
      project.attachment = File.open("#{Rails.root}/spec/fixtures/landscape_5x7.jpg")
      expect(project.save).to be_truthy
    end

    it 'should accept a landscape 5x7 tiff' do
      project.attachment = File.open("#{Rails.root}/spec/fixtures/landscape_5x7.tiff")
      expect(project.save).to be_truthy
    end

    it 'should accept a portrait 5x7 tif' do
      project.attachment = File.open("#{Rails.root}/spec/fixtures/portrait_5x7.tif")
      expect(project.save).to be_truthy
    end

    it 'should accept a portrait 5x7 jpg' do
      project.attachment = File.open("#{Rails.root}/spec/fixtures/portrait_5x7.jpg")
      expect(project.save).to be_truthy
    end

    it 'should accept a portrait 5x7 tiff' do
      project.attachment = File.open("#{Rails.root}/spec/fixtures/portrait_5x7.tiff")
      expect(project.save).to be_truthy
    end

    it 'should reject something too small (jpg)' do
      project.attachment = Rails.root.join("spec/fixtures/portrait_invalid.jpg").open
      expect(project.save).to be_falsey
    end

    it 'should reject something too small (tiff)' do
      project.attachment = Rails.root.join("spec/fixtures/landscape_invalid.tiff").open
      expect(project.save).to be_falsey
    end

  end

end
