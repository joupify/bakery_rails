products = [
  {
    name: "Baguette de Tradition",
    description: "Dorée, craquante, façonnée à la main. Croûte épaisse, mie alvéolée.",
    price_cents: 120,
    image: "image_2.jpg"
  },
  {
    name: "Tarte aux Fruits Rouges",
    description: "Framboises, mûres, fraises sur crème pâtissière vanille.",
    price_cents: 650,
    image: "image_4.jpg"
  },
  {
    name: "Cake Chocolat & Brioches",
    description: "Cake moelleux intense et brioches dorées au beurre.",
    price_cents: 380,
    image: "image_5.jpg"
  },
  {
    name: "Petits Gâteaux Glacés",
    description: "Entremets de saison à la finition miroir.",
    price_cents: 550,
    image: "image_6.jpg"
  },
  {
    name: "Formule Petit-Déjeuner",
    description: "Café, croissant pur beurre et jus d'orange pressé.",
    price_cents: 690,
    image: "image_7.jpg"
  },
  {
    name: "Tarte Halloween",
    description: "Tarte caramel araignée et miroir orange.",
    price_cents: 750,
    image: "hallloeeen.jpg"
  },
  {
    name: "Poussins de Pâques",
    description: "Tartelettes citron, crème yuzu et chocolat blanc.",
    price_cents: 450,
    image: "poussins_de_paques.jpg"
  }
]

products.each do |attributes|
  product = Product.find_or_initialize_by(name: attributes[:name])
  product.assign_attributes(attributes)
  product.save!
end

puts "#{Product.count} produits présents."