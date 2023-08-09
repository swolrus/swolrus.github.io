---
title: TypeScript Tips
---

> A collection of typescript tricks, also a super quick definition for y'all.
> See [this](https://www.youtube.com/watch?v=sRWE5tnaxlI) video on JS Fuck to get it... Get it now?

## Definitions
### TypeScript
TypeScript (TS) is a super-set of JavaScript (JS). At compile time JS is emitted from your TS work. It allows for stricter typing and object-oriented classing to JS. This fixes many of JS's issues around mismatching types and not being very portable.

### {File}.ts vs {File}.tsx?

This question is simpler than it seems. React utilises a syntax called JSX which allows for elements reminiscent of HTML to be defined directly within JavaScript. This difference in syntax is indicated to IDE's and developers via the `.jsx` rather than `.js` extension.
This separation carries over to TypeScript.

## Features
### Enums
> TS allows for easier seperation between const values and enums.

```typescript
// TypeScript enum declaration
enum Direction {
  Up,
  Down,
  Left,
  Right
}
// JavaScript equivalent, TS will compile an enum into this anyway
const Direction = {
  Up: 'Up',
  Down: 'Down',
  Left: 'Left',
  Right: 'Right'
};
```

## Tricks
### Create a type from:
#### Object keys and values
```typescript
const homer = {
  mistake: "D'oh!",
  iq: 105,
  hair: "Balding",
};

// type Keys = "mistake" | "iq" | "hair"
type Keys = keyof typeof homer;

// type Values = string | number
type Values = (typeof homer)[Keys];
```

#### Keys of your Type
```typescript
type Homer = {
  mistake: "D'oh!",
  iq: 105,
  hair: "Balding",
};

// type Keys = "mistake" | "iq" | "hair"
type Keys = keyof Homer;

// type Values = string | number
type Values = (typeof homer)[Keys];
```


