require "rails_helper"

describe "アプリ起動", type: :system do
  describe "1ページ目遷移" do
    before do
      visit nogikuis_index_path
      FactoryBot.create(:question_sort)
      FactoryBot.create(:option)
      click_on "クイズを始める"
      visit "/nogikuis/1"
    end
    it "問題ページが表示される" do
      expect(page).to have_css ".question"
    end

    it "Judgeレコードが作成される" do
      click_button "op_test"
      judge = FactoryBot.create(:judge)
      expect(judge).to be_valid
    end
  end
end