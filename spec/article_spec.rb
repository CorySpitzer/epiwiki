require "spec_helper"

describe(Article) do
  it { should have_and_belong_to_many(:users)}
  it { should validate_presence_of :name}
  it { should validate_presence_of :content}

  it('downcases the all content in the article') do
    article = Article.create content: "This Is soMe gooD StuFF", name:'Stuff'
    expect(article.content).to eq('this is some good stuff')
  end

  it('downcases the name of the article') do
    article = Article.create content: "This Is soMe gooD StuFF", name:'Stuff'
    expect(article.name).to eq('stuff')
  end

  describe('#revision?') do
    it('returns true if two articles have the same name') do
      article1 = Article.create name: "A1", content: 'some stuff'
      article2 = Article.create name: "A1", content: 'other stuff'
      expect(article1.revision?(article2)).to eq(true)
    end

    it('returns false if they do not have the same name') do
      article1 = Article.create name: "A1", content: 'some stuff'
      article2 = Article.create name: "A2", content: 'some stuff'
      expect(article1.revision?(article2)).to eq(false)
    end
  end

  describe('#user_revisions') do
    it 'allows us to count the number of user revisions' do
      article1 = Article.create name: "A1", content: 'some stuff'
      Article.create name: "A1", content: 'some more stuff'
      Article.create name: "A1", content: 'some other stuff'
      expect(article1.user_revisions.length).to eq(3)
    end

    it 'returns a list of articles that are revisions' do
      article1 = Article.create name: "A1", content: 'some stuff'
      article2 = Article.create name: "A1", content: 'some more stuff'
      article3 = Article.create name: "A1", content: 'some other stuff'
      expect(article1.user_revisions).to eq([article1, article2, article3])
    end
  end

  it('is equal if and only if name and content are the same') do
    article1 = Article.create name: "A1", content: 'some stuff'
    article2 = Article.create name: "A1", content: 'some stuff'
    article3 = Article.create name: "A2", content: 'some stuff'
    expect(article1).to eq(article2)
    expect(article2.==(article3)).to eq(false)
  end
end
