class Recipe ({
  required final String title,
  required final String imageUrl,
  required final String category,
  required final int minutes,
  required final int servings,
  required final List<String> ingredients,
  required final List<String> steps,
});

final arrabiata = Recipe(
  title: 'Pasta Arrabiata',
  imageUrl: 'https://i.blogs.es/19c40e/penne/1366_2000.jpg',
  category: 'Vegetariana',
  minutes: 30,
  servings: 4,
  ingredients: [
    '400 g de pasta (penne o espaguetis)',
    '2 dientes de ajo',
    '1 guindilla roja',
    '400 g de tomate triturado',
    'Aceite de oliva virgen extra',
    'Sal y pimienta al gusto',
    'Perejil fresco picado (opcional)',
  ],
  steps: [
    'Cocer la pasta en agua con sal según las instrucciones del paquete.',
    'En una sartén grande, calentar aceite de oliva y añadir el ajo picado y la guindilla. Sofreír hasta que el ajo esté dorado.',
    'Añadir el tomate triturado, sal y pimienta. Cocinar a fuego medio durante unos 10-15 minutos.',
    'Escurrir la pasta y añadirla a la salsa. Mezclar bien para que se impregne de la salsa.',
    'Servir caliente, espolvoreado con perejil fresco si se desea.',
  ],
);