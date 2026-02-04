DROP DATABASE IF EXISTS BioBank_Souches;
CREATE DATABASE BioBank_Souches;
USE BioBank_Souches;

-- 2. CRÉATION DES TABLES (STRUCTURE PREMIUM VALIDÉE)

CREATE TABLE milieux (
    id_milieu INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    composition TEXT,
    temp_optimale DECIMAL(3,1)
);

CREATE TABLE tests_biochimiques (
    id_test INT AUTO_INCREMENT PRIMARY KEY,
    nom_test VARCHAR(100) NOT NULL UNIQUE,
    resultat_attendu VARCHAR(100)
);

CREATE TABLE antibiotiques (
    id_antibio INT AUTO_INCREMENT PRIMARY KEY,
    nom_molecule VARCHAR(100) NOT NULL UNIQUE,
    famille_chimique VARCHAR(100)
);

CREATE TABLE emplacements (
    id_emplacement INT AUTO_INCREMENT PRIMARY KEY,
    numero_frigo VARCHAR(20) NOT NULL,
    etage INT NOT NULL,
    boite INT NOT NULL,
    position INT NOT NULL,
    CONSTRAINT uc_position UNIQUE (numero_frigo, etage, boite, position)
);

CREATE TABLE souches (
    ref_souche VARCHAR(20) PRIMARY KEY,
    genre VARCHAR(50) NOT NULL,
    espece VARCHAR(50) NOT NULL,
    source_isolement VARCHAR(100),
    id_emplacement INT,
    FOREIGN KEY (id_emplacement) REFERENCES emplacements(id_emplacement)
);

CREATE TABLE cultures (
    id_culture INT AUTO_INCREMENT PRIMARY KEY,
    ref_souche VARCHAR(20) NOT NULL,
    id_milieu INT NOT NULL,
    date_culture DATE DEFAULT (CURRENT_DATE),
    observation TEXT,
    FOREIGN KEY (ref_souche) REFERENCES souches(ref_souche) ON DELETE CASCADE,
    FOREIGN KEY (id_milieu) REFERENCES milieux(id_milieu)
);

CREATE TABLE resultats_tests (
    ref_souche VARCHAR(20) NOT NULL,
    id_test INT NOT NULL,
    resultat_obtenu ENUM('Positif', 'Négatif', 'Indéterminé'),
    date_test DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (ref_souche, id_test),
    FOREIGN KEY (ref_souche) REFERENCES souches(ref_souche) ON DELETE CASCADE,
    FOREIGN KEY (id_test) REFERENCES tests_biochimiques(id_test)
);

CREATE TABLE antibiogrammes (
    ref_souche VARCHAR(20) NOT NULL,
    id_antibio INT NOT NULL,
    statut_SIR ENUM('Sensible', 'Intermédiaire', 'Résistant'),
    mic_valeur FLOAT, -- Concentration Minimale Inhibitrice (La touche Pro)
    PRIMARY KEY (ref_souche, id_antibio),
    FOREIGN KEY (ref_souche) REFERENCES souches(ref_souche) ON DELETE CASCADE,
    FOREIGN KEY (id_antibio) REFERENCES antibiotiques(id_antibio)
);

-- I. Remplissage des CATALOGUES (Milieux, Tests, Antibios, Emplacements)
INSERT INTO milieux (nom, composition, temp_optimale) VALUES
('Gélose au Sang', 'Sang de mouton 5%, Agar', 37.0),
('Gélose MacConkey', 'Sels biliaires, Cristal violet, Lactose', 37.0),
('Gélose CLED', 'Cystine, Lactose, Electrolyte Deficient', 37.0),
('Gélose Sabouraud', 'Peptones, Glucose, pH acide', 25.0), 
('Bouillon Mueller-Hinton', 'Infusion de bœuf, Caséine', 37.0),
('Gélose Chocolat', 'Sang cuit, Facteurs V et X', 37.0), 
('Bouillon Rappaport', 'Vert malachite, Chlorure magnésium', 42.0); 

INSERT INTO tests_biochimiques (nom_test, resultat_attendu) VALUES
('Catalase', 'Effervescence (H2O2)'),
('Oxydase', 'Coloration violette'),
('Coagulase', 'Caillot de fibrine'),
('Indole', 'Anneau rouge (Kovacs)'),
('Uréase', 'Coloration rose'),
('Citrate de Simmons', 'Virage au bleu'),
('TSI (Pente)', 'Fermentation sucres'),
('Mobilité', 'Trouble du milieu'), 
('Réduction Nitrates', 'Rouge après réactifs');

INSERT INTO antibiotiques (nom_molecule, famille_chimique) VALUES
('Amoxicilline', 'Pénicillines'),
('Gentamicine', 'Aminosides'),
('Ciprofloxacine', 'Fluoroquinolones'),
('Erythromycine', 'Macrolides'),
('Vancomycine', 'Glycopeptides'),
('Tétracycline', 'Tétracyclines'),
('Ceftriaxone', 'Céphalosporines'),
('Imipénème', 'Carbapénèmes');

-- Création de 30 emplacements dans le Frigo A
INSERT INTO emplacements (numero_frigo, etage, boite, position) VALUES
('FRIGO-A', 1, 1, 1), ('FRIGO-A', 1, 1, 2), ('FRIGO-A', 1, 1, 3), ('FRIGO-A', 1, 1, 4), ('FRIGO-A', 1, 1, 5),
('FRIGO-A', 1, 1, 6), ('FRIGO-A', 1, 1, 7), ('FRIGO-A', 1, 1, 8), ('FRIGO-A', 1, 1, 9), ('FRIGO-A', 1, 1, 10),
('FRIGO-A', 1, 2, 1), ('FRIGO-A', 1, 2, 2), ('FRIGO-A', 1, 2, 3), ('FRIGO-A', 1, 2, 4), ('FRIGO-A', 1, 2, 5),
('FRIGO-A', 2, 1, 1), ('FRIGO-A', 2, 1, 2), ('FRIGO-A', 2, 1, 3), ('FRIGO-A', 2, 1, 4), ('FRIGO-A', 2, 1, 5),
('FRIGO-A', 2, 2, 1), ('FRIGO-A', 2, 2, 2), ('FRIGO-A', 2, 2, 3), ('FRIGO-A', 2, 2, 4), ('FRIGO-A', 2, 2, 5),
('FRIGO-A', 3, 1, 1), ('FRIGO-A', 3, 1, 2), ('FRIGO-A', 3, 1, 3), ('FRIGO-A', 3, 1, 4), ('FRIGO-A', 3, 1, 5);

-- II. Remplissage des SOUCHES (30 Souches Variées)
INSERT INTO souches (ref_souche, genre, espece, source_isolement, id_emplacement) VALUES
('ST-2024-001', 'Escherichia', 'coli', 'Urine', 1),
('ST-2024-002', 'Staphylococcus', 'aureus', 'Pus', 2),
('ST-2024-003', 'Pseudomonas', 'aeruginosa', 'Expectoration', 3),
('ST-2024-004', 'Klebsiella', 'pneumoniae', 'Urine', 4),
('ST-2024-005', 'Salmonella', 'enterica', 'Selles', 5),
('ST-2024-006', 'Candida', 'albicans', 'Prélèvement vaginal', 6),
('ST-2024-007', 'Streptococcus', 'pyogenes', 'Gorge', 7),
('ST-2024-008', 'Enterococcus', 'faecalis', 'Urine', 8),
('ST-2024-009', 'Escherichia', 'coli', 'Sang', 9),
('ST-2024-010', 'Staphylococcus', 'epidermidis', 'Cathéter', 10),
('ST-2024-011', 'Proteus', 'mirabilis', 'Urine', 11),
('ST-2024-012', 'Acinetobacter', 'baumannii', 'Respiratoire', 12),
('ST-2024-013', 'Neisseria', 'gonorrhoeae', 'Urétrale', 13),
('ST-2024-014', 'Haemophilus', 'influenzae', 'LCR', 14),
('ST-2024-015', 'Listeria', 'monocytogenes', 'Fromage', 15),
-- Ajout des 15 souches supplémentaires (+30%)
('ST-2024-016', 'Bacillus', 'cereus', 'Alimentaire', 16),
('ST-2024-017', 'Clostridium', 'difficile', 'Selles', 17),
('ST-2024-018', 'Vibrio', 'cholerae', 'Eau', 18),
('ST-2024-019', 'Legionella', 'pneumophila', 'Eau chaude', 19),
('ST-2024-020', 'Helicobacter', 'pylori', 'Biopsie gastrique', 20),
('ST-2024-021', 'Escherichia', 'coli', 'Selles', 21), 
('ST-2024-022', 'Staphylococcus', 'aureus', 'Nez', 22), 
('ST-2024-023', 'Streptococcus', 'pneumoniae', 'Poumon', 23),
('ST-2024-024', 'Mycobacterium', 'tuberculosis', 'Crachat', 24),
('ST-2024-025', 'Shigella', 'sonnei', 'Selles', 25),
('ST-2024-026', 'Campylobacter', 'jejuni', 'Poulet', 26),
('ST-2024-027', 'Yersinia', 'pestis', 'Ganglion', 27),
('ST-2024-028', 'Bordetella', 'pertussis', 'Nasopharynx', 28),
('ST-2024-029', 'Chlamydia', 'trachomatis', 'Urogénital', 29),
('ST-2024-030', 'Mycoplasma', 'pneumoniae', 'Gorge', 30);

-- III. Remplissage des CULTURES
INSERT INTO cultures (ref_souche, id_milieu, date_culture, observation) VALUES
('ST-2024-001', 2, '2024-01-10', 'Colonies roses (Lactose +)'), -- E. coli sur MacConkey
('ST-2024-001', 3, '2024-01-12', 'Colonies jaunes opaques'),
('ST-2024-002', 1, '2024-01-15', 'Hémolyse bêta complète'), -- Staph sur Sang
('ST-2024-002', 5, '2024-01-16', 'Culture abondante'),
('ST-2024-003', 5, '2024-01-20', 'Pigment vert (Pyocyanine)'), -- Pseudomonas
('ST-2024-004', 2, '2024-02-01', 'Colonies muqueuses'), -- Klebsiella
('ST-2024-005', 2, '2024-02-05', 'Colonies incolores (Lactose -)'), -- Salmonella
('ST-2024-006', 4, '2024-02-10', 'Colonies blanches crémeuses'), -- Candida sur Sabouraud
('ST-2024-007', 1, '2024-02-12', 'Petites colonies, Hémolyse bêta'),
('ST-2024-008', 3, '2024-02-15', 'Petites colonies grises'),
('ST-2024-009', 2, '2024-02-20', 'Colonies roses'),
('ST-2024-010', 1, '2024-02-22', 'Colonies blanches non hémolytiques'),
('ST-2024-011', 2, '2024-03-01', 'Envahissement en nappe'), -- Proteus
('ST-2024-012', 5, '2024-03-05', 'Colonies lisses'),
('ST-2024-013', 6, '2024-03-10', 'Petites colonies transparentes'), -- Gonocoque sur Chocolat
('ST-2024-014', 6, '2024-03-12', 'Odeur spermatique'),
('ST-2024-015', 1, '2024-03-15', 'Faible hémolyse'),
('ST-2024-016', 1, '2024-03-20', 'Grandes colonies mates'),
('ST-2024-017', 1, '2024-03-22', 'Culture anaérobie stricte'),
('ST-2024-018', 7, '2024-03-25', 'Colonies jaunes'), -- Vibrio
('ST-2024-019', 6, '2024-04-01', 'Verre fritté'),
('ST-2024-020', 1, '2024-04-05', 'Croissance lente'),
('ST-2024-021', 2, '2024-04-10', 'Colonies roses'),
('ST-2024-022', 5, '2024-04-12', 'Pigment doré'),
('ST-2024-023', 1, '2024-04-15', 'Colonies en "nombril"'),
('ST-2024-024', 5, '2024-04-20', 'Culture type "chou-fleur"'),
('ST-2024-025', 2, '2024-04-25', 'Colonies incolores'),
('ST-2024-026', 1, '2024-05-01', 'Colonies étalées'),
('ST-2024-027', 2, '2024-05-05', 'Culture difficile'),
('ST-2024-028', 6, '2024-05-10', 'Gouttelettes de mercure'),
('ST-2024-001', 1, '2024-05-12', 'Hémolyse non visible'),
('ST-2024-001', 5, '2024-05-15', 'Turbidité forte'),
('ST-2024-002', 2, '2024-05-18', 'Pas de croissance (Sels biliaires)'),
('ST-2024-002', 3, '2024-05-20', 'Colonies jaunes'),
('ST-2024-003', 1, '2024-05-22', 'Reflet métallique'),
('ST-2024-004', 3, '2024-05-25', 'Colonies jaunes'),
('ST-2024-005', 7, '2024-05-28', 'Colonies à centre noir'),
('ST-2024-009', 3, '2024-06-01', 'Colonies jaunes'),
('ST-2024-010', 5, '2024-06-05', 'Turbidité moyenne'),
('ST-2024-011', 1, '2024-06-10', 'Odeur désagréable'),
('ST-2024-021', 3, '2024-06-15', 'Colonies jaunes'),
('ST-2024-022', 1, '2024-06-20', 'Hémolyse forte'),
('ST-2024-023', 6, '2024-06-25', 'Culture fragile'),
('ST-2024-030', 5, '2024-06-30', 'Aspect "oeuf sur le plat"');

-- IV. Remplissage des RÉSULTATS TESTS
INSERT INTO resultats_tests (ref_souche, id_test, resultat_obtenu) VALUES
-- E. coli (Ref 001) : Oxydase -, Indole +
('ST-2024-001', 2, 'Négatif'), ('ST-2024-001', 4, 'Positif'), ('ST-2024-001', 1, 'Positif'),
-- Staph aureus (Ref 002) : Catalase +, Coagulase +
('ST-2024-002', 1, 'Positif'), ('ST-2024-002', 3, 'Positif'), ('ST-2024-002', 2, 'Négatif'),
-- Pseudomonas (Ref 003) : Oxydase +
('ST-2024-003', 2, 'Positif'), ('ST-2024-003', 1, 'Positif'), ('ST-2024-003', 6, 'Positif'),
-- Klebsiella (Ref 004) : Indole -, Uréase +
('ST-2024-004', 4, 'Négatif'), ('ST-2024-004', 5, 'Positif'),
-- Proteus (Ref 011) : Uréase +++ (Rose intense)
('ST-2024-011', 5, 'Positif'), ('ST-2024-011', 4, 'Négatif'),
-- Autres tests variés pour le volume
('ST-2024-005', 1, 'Positif'), ('ST-2024-005', 2, 'Négatif'), ('ST-2024-005', 7, 'Positif'),
('ST-2024-006', 1, 'Positif'), -- Candida
('ST-2024-007', 1, 'Négatif'), -- Streptocoque (Catalase -)
('ST-2024-008', 1, 'Négatif'),
('ST-2024-009', 4, 'Positif'), -- E. coli 2
('ST-2024-010', 3, 'Négatif'), -- Staph epidermidis (Coagulase -)
('ST-2024-012', 2, 'Négatif'),
('ST-2024-013', 2, 'Positif'), -- Gonocoque Oxydase +
('ST-2024-014', 1, 'Positif'),
('ST-2024-015', 1, 'Positif'), ('ST-2024-015', 8, 'Positif'), -- Listeria mobile
('ST-2024-016', 1, 'Positif'),
('ST-2024-017', 1, 'Négatif'), -- Clostridium
('ST-2024-018', 2, 'Positif'), -- Vibrio Oxydase +
('ST-2024-019', 1, 'Positif'),
('ST-2024-020', 5, 'Positif'), -- Helicobacter Uréase +
('ST-2024-021', 4, 'Positif'),
('ST-2024-022', 3, 'Positif'),
('ST-2024-023', 1, 'Négatif'),
('ST-2024-024', 9, 'Positif'), -- BK Nitrate +
('ST-2024-025', 8, 'Négatif'), -- Shigella Immobile
('ST-2024-026', 2, 'Positif'),
('ST-2024-027', 1, 'Positif'),
('ST-2024-028', 2, 'Positif'),
('ST-2024-029', 1, 'Indéterminé'),
('ST-2024-030', 1, 'Indéterminé'),
-- Quelques tests en plus pour E. coli 001
('ST-2024-001', 6, 'Négatif'), ('ST-2024-001', 5, 'Négatif'), ('ST-2024-001', 9, 'Positif'),
-- Quelques tests en plus pour Staph 002
('ST-2024-002', 5, 'Positif'), ('ST-2024-002', 9, 'Positif'), ('ST-2024-002', 4, 'Négatif'),
-- Tests en plus pour Pseudomonas
('ST-2024-003', 5, 'Négatif'), ('ST-2024-003', 4, 'Négatif'), ('ST-2024-003', 8, 'Positif');

-- V. Remplissage des ANTIBIOGRAMMES (80 Mesures SIR)
INSERT INTO antibiogrammes (ref_souche, id_antibio, statut_SIR, mic_valeur) VALUES
-- E. coli (001) : Sensible sauf Ampicilline souvent R
('ST-2024-001', 1, 'Résistant', 32.0), ('ST-2024-001', 3, 'Sensible', 0.5), ('ST-2024-001', 2, 'Sensible', 2.0),
-- Staph aureus (002) : Souvent Péni R (SARM possible)
('ST-2024-002', 1, 'Résistant', 64.0), ('ST-2024-002', 5, 'Sensible', 1.0), ('ST-2024-002', 4, 'Résistant', 8.0),
-- Pseudomonas (003) : Résistant naturel à beaucoup
('ST-2024-003', 1, 'Résistant', 128.0), ('ST-2024-003', 3, 'Sensible', 0.25), ('ST-2024-003', 7, 'Intermédiaire', 16.0),
-- Klebsiella (004) : BLSE possible
('ST-2024-004', 1, 'Résistant', 64.0), ('ST-2024-004', 7, 'Résistant', 32.0), ('ST-2024-004', 8, 'Sensible', 0.5),
-- Remplissage en volume
('ST-2024-005', 1, 'Sensible', 4.0), ('ST-2024-005', 3, 'Sensible', 0.06),
('ST-2024-006', 1, 'Résistant', NULL), -- Candida résistant antibios
('ST-2024-007', 1, 'Sensible', 0.03), -- Strepto sensible Péni
('ST-2024-008', 5, 'Sensible', 2.0),
('ST-2024-009', 3, 'Résistant', 4.0), -- E. coli résistant Quinolone
('ST-2024-010', 5, 'Sensible', 2.0),
('ST-2024-011', 1, 'Résistant', 16.0),
('ST-2024-012', 8, 'Sensible', 1.0), -- Acineto sensible Imipénème
('ST-2024-013', 7, 'Sensible', 0.004), -- Gono sensible Ceftriaxone
('ST-2024-014', 1, 'Intermédiaire', 2.0),
('ST-2024-015', 1, 'Sensible', 1.0),
('ST-2024-016', 5, 'Sensible', 1.0),
('ST-2024-017', 5, 'Sensible', 2.0),
('ST-2024-018', 6, 'Sensible', 1.0),
('ST-2024-019', 4, 'Sensible', 0.5),
('ST-2024-020', 1, 'Sensible', 0.25),
('ST-2024-021', 1, 'Résistant', 32.0),
('ST-2024-022', 1, 'Résistant', 64.0), ('ST-2024-022', 5, 'Sensible', 2.0), -- SARM
('ST-2024-023', 1, 'Intermédiaire', 1.0), -- PSDP
('ST-2024-024', 1, 'Résistant', NULL), -- BK résistant classique
('ST-2024-025', 3, 'Sensible', 0.1),
('ST-2024-026', 4, 'Sensible', 0.5),
('ST-2024-027', 6, 'Sensible', 2.0),
('ST-2024-028', 4, 'Sensible', 1.0),
('ST-2024-029', 6, 'Sensible', 0.5),
('ST-2024-030', 4, 'Sensible', 0.5),
-- Quelques résistances supplémentaires pour les stats
('ST-2024-001', 6, 'Résistant', 16.0),
('ST-2024-002', 3, 'Résistant', 4.0),
('ST-2024-003', 2, 'Résistant', 32.0),
('ST-2024-004', 2, 'Sensible', 1.0),
('ST-2024-005', 7, 'Sensible', 0.5),
('ST-2024-011', 3, 'Sensible', 0.25),
('ST-2024-012', 7, 'Résistant', 64.0),
('ST-2024-021', 3, 'Sensible', 0.5),
('ST-2024-022', 4, 'Résistant', 8.0);
-- 1. Lister toutes les souches isolées à partir d'un "Prélèvement urinaire" (ou contient 'Urine')
-- Objectif : Filtrage simple de texte.
SELECT ref_souche, genre, espece, source_isolement 
FROM souches 
WHERE source_isolement LIKE '%Urine%';

-- 2. Afficher le catalogue complet des milieux de culture avec leur température idéale.
-- Objectif : Lecture de table de référence.
SELECT nom, temp_optimale 
FROM milieux 
ORDER BY temp_optimale DESC;

-- 3. Gestion de Stock : Où est rangée exactement la souche 'ST-2024-001' ?
-- Objectif : Jointure simple pour localiser un item (Biobanque).
SELECT s.ref_souche, e.numero_frigo, e.etage, e.boite, e.position
FROM souches s
JOIN emplacements e ON s.id_emplacement = e.id_emplacement
WHERE s.ref_souche = 'ST-2024-001';

-- 4. Rapport d'activité : Qui a été cultivé, quand et sur quel milieu ?
SELECT c.date_culture, s.espece, m.nom AS milieu_utilise, c.observation
FROM cultures c
JOIN souches s ON c.ref_souche = s.ref_souche
JOIN milieux m ON c.id_milieu = m.id_milieu
ORDER BY c.date_culture DESC;

-- 5. Recherche Phénotypique : Quelles souches sont "Oxydase Positif" ?
SELECT s.ref_souche, s.genre, s.espece, t.nom_test, r.resultat_obtenu
FROM souches s
JOIN resultats_tests r ON s.ref_souche = r.ref_souche
JOIN tests_biochimiques t ON r.id_test = t.id_test
WHERE t.nom_test = 'Oxydase' AND r.resultat_obtenu = 'Positif';

-- 6. Contrôle Qualité : Y a-t-il des souches qui n'ont JAMAIS été cultivées ?
SELECT s.ref_souche, s.espece
FROM souches s
LEFT JOIN cultures c ON s.ref_souche = c.ref_souche
WHERE c.id_culture IS NULL;

-- 7. Dossier Patient : Historique complet du 'Staphylococcus aureus' (Ref ST-2024-002)
-- Objectif : Tout savoir sur une souche précise.
SELECT t.nom_test, r.resultat_obtenu
FROM resultats_tests r
JOIN tests_biochimiques t ON r.id_test = t.id_test
WHERE r.ref_souche = 'ST-2024-002';

-- 8. Pharmacogénomique : Quelles souches sont résistantes aux "Pénicillines" ?
SELECT s.genre, s.espece, a.nom_molecule, anti.statut_SIR
FROM souches s
JOIN antibiogrammes anti ON s.ref_souche = anti.ref_souche
JOIN antibiotiques a ON anti.id_antibio = a.id_antibio
WHERE a.famille_chimique = 'Pénicillines' AND anti.statut_SIR = 'Résistant';

-- 9. Statistiques Labo : Quel est le % de résistance pour chaque antibiotique ?
SELECT a.nom_molecule,
       COUNT(anti.ref_souche) as total_tests,
       SUM(CASE WHEN anti.statut_SIR = 'Résistant' THEN 1 ELSE 0 END) as nb_resistants,
       ROUND((SUM(CASE WHEN anti.statut_SIR = 'Résistant' THEN 1 ELSE 0 END) / COUNT(anti.ref_souche)) * 100, 2) as pourcentage_resistance
FROM antibiogrammes anti
JOIN antibiotiques a ON anti.id_antibio = a.id_antibio
GROUP BY a.nom_molecule
ORDER BY pourcentage_resistance DESC;

-- 10. Alerte Santé Publique : Identifier les souches "Multirésistantes" (BMR)
-- Objectif : Filtrer sur un groupe (HAVING COUNT > 2).
SELECT s.ref_souche, s.espece, COUNT(anti.id_antibio) as nb_resistances
FROM souches s
JOIN antibiogrammes anti ON s.ref_souche = anti.ref_souche
WHERE anti.statut_SIR = 'Résistant'
GROUP BY s.ref_souche, s.espece
HAVING nb_resistances >= 2
ORDER BY nb_resistances DESC;

-- 11. Gestion Biobanque : Taux d'occupation par étage du "FRIGO-A"
-- Objectif : Optimisation de l'espace de stockage (Utilise ta table Emplacements).
SELECT e.etage, COUNT(s.ref_souche) as nb_souches_stockees
FROM emplacements e
LEFT JOIN souches s ON e.id_emplacement = s.id_emplacement
WHERE e.numero_frigo = 'FRIGO-A'
GROUP BY e.etage
ORDER BY e.etage;

-- 12. Analyse Scientifique : Moyenne des CMI (MIC) par Famille d'Antibiotique
-- Objectif : Utiliser la colonne scientifique 'mic_valeur' pour une analyse fine.
SELECT a.famille_chimique, ROUND(AVG(anti.mic_valeur), 2) as CMI_Moyenne_mg_L
FROM antibiogrammes anti
JOIN antibiotiques a ON anti.id_antibio = a.id_antibio
WHERE anti.mic_valeur IS NOT NULL
GROUP BY a.famille_chimique;
