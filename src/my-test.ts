import {Selector} from 'testcafe'

fixture`Getting Started`.page`https://devexpress.github.io/testcafe/example`
  .meta('fixtureID', 'myFirstTest')
  .meta({author: 'Butel Benjamin'})

test('My successful test', async t => {
  await t
    .typeText('#developer-name', 'John Smith')
    .click('#submit-button')
    .expect(Selector('#article-header').innerText)
    .eql('Thank you, John Smith!')
})

test('My failed test', async t => {
  await t
    .typeText('#FAILED-SELECTOR', 'John Smith')
    .click('#submit-button')
    .expect(Selector('#article-header').innerText)
    .eql('Thank you, John Smith!')
})