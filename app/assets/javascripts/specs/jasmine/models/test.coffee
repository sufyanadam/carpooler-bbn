describe "Test", ->
  it "works", ->
    test = new App.Models.Test()
    expect(test.works()).toBe true