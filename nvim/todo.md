## Plugins

- [ ] Coc — it has nice hover for TS and snippets


## Syntax

CSS wrong syntax highlight:

```css
.button:not(:disabled):hover {
  box-shadow: 0 2px 20px rgba(255, 255, 255, 0.3);
}
```

Shitty, that array keys aren't highlighted:

```js
describe('Build Chart Data', () => {
  it('should work', () => {
    const res = builder(data);
    expect(res.length).toBe(365);
    res['2019-11-06'].summary.toBe(650000);
    res['2019-11-13'].summary.toBe(66000);
  });
});
```
