# encoding: utf-8 
task :set_position => :environment do

  p = Player.find_by_name('Antelo, J. A.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Neto, Raulzinho')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Buycks, Dwight')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Loncar, Kresimir')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Harangody, Luke')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Pullen, Jacob')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Byars, Derrick')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Thames, Xavier')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Urtasun, Alex')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Porzingis, K.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Gallardo, Diego')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Hernangómez, W.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Rodríguez, B.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('San Miguel, R.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Richotti, Nicolás')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Tsairelis, M.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Heras, Jaime')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Lampropoulos,F.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Beirán, Javier')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Rost, Levi')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Lisch, Kevin')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Katic, Rasko')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Robinson, Jason')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Landry, Marcus')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Fontet, Albert')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Goulding, Chris')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Kirksay, Tariq')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Martínez, Ander')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Simpson, Diamon')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Nunnally, James')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Hernangómez, J.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Ortega, Pep')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Dean, Taquan')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Jordan, Jared')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Huskic, Goran')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Iarochevitch, I.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Franch, Josep')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Díez, Daniel')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Rivers, K. C.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Campazzo, Facu')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Rodríguez, S.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Bourousis, I.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Mejri, Salah')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Bellas, Tomàs')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Kendall, Levon')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Santana, Fabio')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Tavares, W.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Summers, DaJuan')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Miller, Daniel')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Pumprla, Pavel')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Triguero, J.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Kleber, Maxi')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Càrdenas, Fran')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Giannopoulos, H.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Corbacho, A.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Nankivil, Keaton')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Luz, Rafa')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Hall, Mike')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Ogilvy, AJ')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Bivià, Carles')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Dewar, Ben')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Garcia, Marc')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Angelats, Nil')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Samuels, Jamar')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Grimau, Roger')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Haritopoulos, D.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Hezonja, Mario')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Huertas, M.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Navarro, J.C.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Pleiss, Tibor')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Thomas, DeShaun')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Lampe, Maciej')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Iverson, Colton')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Gomes, Ryan')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Perkins, Doron')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('San Emeterio')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Heurtel, Thomas')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Johnson, Orlando')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Bertans, Davis')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Vasileiadis, K.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Toolson, Ryan')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Nguirane, Maodo')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Granger, Jayson')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Stefansson, J.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Green, Caleb')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Golubovic, V.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Green, Shaun')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Martínez, Román')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Blanch, Marc')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Ivanov, Kaloyan')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Colom, Quino')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Todorovic, Marko')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Williams, L.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('López, Raúl')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Andjusic, Danilo')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Pérez, Daniel')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Panko, Andy')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Vega, Javier')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Akindele, Jeleel')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Baron, Jimmy')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Papamakarios, M.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Miso, Andrés')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('White, DJ')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Shengelia, T.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Hakanson, Ludde')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Martí, Marc')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Watts, Dane')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Spires, Nick')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Knezevic, Filip')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Van Lacke, Fede')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Belemene, Romaric')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Sakic, Zeljko')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Rizvic, Hasan')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Lliteras, Roger')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Wragge, Ethan')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Colom, Guillem')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Satoransky, T.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Dubljevic, Bojan')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Pérez, Pablo')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Moungoro, B.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Hamilton, Lamont')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Mbansogo, S.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Soluade, Morayo')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Oroz, Xabi')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Vujacic, Sasha')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Isiani, Willy')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Karahodzic, Kenan')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Orlov, Volodymyr')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Begic, Mirza')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Rodríguez, A.')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Barro, Mouhamed')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Slaughter, M.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Woodside, Ben')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Thomas, D.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Duch, Adrià')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Summers, D.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Llorente, Juan')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Martínez, Eric')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Peno, Stefan')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Burtt, Steve')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Alvarado, Óscar')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Esteban, Màxim')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Vila, Eric')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Aradori, Pietro')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Jawai, Nathan')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Huertas, Rafael')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Hansbrough, Ben')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Portugués, Joaquín')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Guardia, David')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Cabrera, Alberto')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Pursl, Simon')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Penney, Kirk')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Bogdanovic, L.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Stojanovski, V.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Lee, Gerald')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Poeta, Giuseppe')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Cvetkovic, B.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Mayo, Josh')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Dilys, Vilmantas')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Little, Mario')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Martínez, Carlos')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Sedekerskis, Tadas')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Creus, Joan')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Nikolic, Zoran')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Seeley, DJ')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Abecrombie, T.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Sánchez, A.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Palsson, Haukur')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Salash, Maksim')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Ortega, José')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Hopson, Scotty')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Maric, Aleks')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Sainsbury, David')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Vitali, Luca')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Jofresa, David')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Vezenkov, A.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Perperoglou, S.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('González, José M.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Sandul, M.')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Otverchenko, R.')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Carter, Kerry')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Rubio, Juan')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Stimac, Vladimir')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Kangur, Kristjan')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Lindstrom, Valter')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Omeragic, Adnan')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('San Martín, José')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Rodríguez, Samuel')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Jou, Guillem')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Brià, Nil')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Torres, Alberto')
  p.position = 'pivot' if p
  p.save! if p
  p = Player.find_by_name('Maura, Alberto')
  p.position = 'alero' if p
  p.save! if p
  p = Player.find_by_name('Sans, Agustín')
  p.position = 'base' if p
  p.save! if p
  p = Player.find_by_name('Llorca, Álex')
  p.position = 'alero' if p
  p.save! if p
end
