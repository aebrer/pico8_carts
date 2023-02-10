// boilerplate 
// $fx.params([
//   {
//     id: "number_id",
//     name: "A number",
//     type: "number",
//     default: 1.2,
//     options: {
//       min: -2,
//       max: 10,
//       step: 0.1,
//     },
//   },
//   {
//     id: "select_id",
//     name: "A selection",
//     type: "select",
//     default: "pear",
//     options: {
//       options: ["apple", "orange", "pear"],
//     }
//   },
//   {
//     id: "color_id",
//     name: "A color",
//     type: "color",
//     default: "ff0000",
//   },
//   {
//     id: "boolean_id",
//     name: "A boolean",
//     type: "boolean",
//     default: true,
//   },
//   {
//     id: "string_id",
//     name: "A string",
//     type: "string",
//     default: "hello",
//     options: {
//       minLength: 1,
//       maxLength: 5
//     }
//   },
// ]);

pico8_cols = [
    "black",
    "dark-blue",
    "dark-purple",
    "dark-green",
    "brown",
    "dark-gray",
    "light-gray",
    "white",
    "red",
    "orange",
    "yellow",
    "green",
    "blue",
    "lavender",
    "pink",
    "light-peach",
    "brownish-black",
    "darker-blue",
    "darker-purple",
    "blue-green",
    "dark-brown",
    "darker-gray",
    "medium-gray",
    "light-yellow",
    "dark-red",
    "dark-orange",
    "lime-green",
    "medium-green",
    "true-blue",
    "mauve",
    "dark-peach",
    "peach"
]


// boilerplate 
$fx.params([
    {
        id: "bg_color",
        name: "Background Color",
        type: "select",
        // default is a random choice from pico8_cols
        default: pico8_cols[Math.floor(Math.random() * pico8_cols.length)],
        options: {
            options: pico8_cols,
        },
    },
    {
        id: "skin2_color",
        name: "Skin Accent Color",
        type: "select",
        default: pico8_cols[Math.floor(Math.random() * pico8_cols.length)],
        options: {
            options: pico8_cols,
        },
    },
    {
        id: "skin1_color",
        name: "Main Skin Color",
        type: "select",
        default: pico8_cols[Math.floor(Math.random() * pico8_cols.length)],
        options: {
            options: pico8_cols,
        },
    },
    {
        id: "eye_color",
        name: "Eye Color",
        type: "select",
        default: pico8_cols[Math.floor(Math.random() * pico8_cols.length)],
        options: {
            options: pico8_cols,
        },
    },
    {
        id: "eye_alt_color",
        name: "Eye Alt Color",
        type: "select",
        default: pico8_cols[Math.floor(Math.random() * pico8_cols.length)],
        options: {
            options: pico8_cols,
        },
    },
]);