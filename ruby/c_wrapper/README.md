Peut être qu'il serait judicieux de mettre le MEMORY en variable globale / static pour éviter de se la trimballer partout dans le code ruby.<br/>

Aussi il faudrait regarder ce qu'il se passe sur ce genre de variable quand le code est appelé depuis du ruby (peut être qu'une nouvelle instance du programme est faites a chaque fois ?).
