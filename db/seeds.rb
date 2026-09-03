products = [
  {
    name: "Baguette de Tradition",
    description: "Dorée, craquante, façonnée à la main. Croûte épaisse, mie alvéolée.",
    price_cents: 120
  },
  {
    name: "Tarte aux Fruits Rouges",
    description: "Framboises, mûres, fraises sur crème pâtissière vanille.",
    price_cents: 650
  },
  {
    name: "Cake Chocolat & Brioches",
    description: "Cake moelleux intense et brioches dorées au beurre.",
    price_cents: 380
  },
  {
    name: "Petits Gâteaux Glacés",
    description: "Entremets de saison à la finition miroir.",
    price_cents: 550
  },
  {
    name: "Formule Petit-Déjeuner",
    description: "Café, croissant pur beurre et jus d'orange pressé.",
    price_cents: 690
  },
  {
    name: "Tarte Halloween",
    description: "Tarte caramel araignée et miroir orange.",
    price_cents: 750
  },
  {
    name: "Poussins de Pâques",
    description: "Tartelettes citron, crème yuzu et chocolat blanc.",
    price_cents: 450
  }
]

products.each do |attributes|
  Product.find_or_create_by!(name: attributes[:name]) do |product|
    product.assign_attributes(attributes)
  end
end

puts "#{Product.count} produits présents."