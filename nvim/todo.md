## plugins

- [ ] coc — it has nice hover for ts and snippets

## syntax

css wrong `syntax` highlight:

```css
.button:not(:disabled):hover {
  box-shadow: 0 2px 20px rgba(255, 255, 255, 0.3);
}
```

shitty, that array keys aren't highlighted:

```javascript
describe('build chart data', () => {
  it('should work', () => {
    const res = builder(data);
    expect(res.length).tobe(365);
    res['2019-11-06'].summary.tobe(650000);
    res['2019-11-13'].summary.tobe(66000);
  });
});
```
