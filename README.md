# Zed Smarty (v0.8.1)

Coloration syntaxique Smarty (`.tpl`) pour Zed, pensée PrestaShop.
Cette version utilise une **grammaire Smarty étendue** (fork) qui colore enfin
les variables d'en-tête de boucle, les tags `{assign}` / `{l}`, et les chaînes.

## Deux dossiers à mettre en place

1. **La grammaire** `tree-sitter-smarty/` → décompresse-la en
   `C:\Users\jerom\Downloads\tree-sitter-smarty`
   (garde le sous-dossier `.git` : Zed récupère le commit indiqué).
   Si tu la mets ailleurs, édite la ligne `repository = "file:///…"` de
   `extension.toml`.
2. **L'extension** `zed-smarty/` → `zed: install dev extension` dessus.

### Version « standalone » (un seul dossier à installer)

Zed ne sait pas embarquer une grammaire dans l'extension : elle est toujours
référencée par dépôt git + `rev` et compilée à l'installation. Pour ne plus
gérer de dossier de grammaire local, héberge-la sur GitHub (une fois) :

```
cd tree-sitter-smarty
git remote add origin https://github.com/iwlabdev-coder/tree-sitter-smarty.git
git push -u origin main      # le SHA du commit ne change pas
```

Puis, dans `extension.toml`, remplace la ligne `repository` par l'URL https
(laisse `rev` tel quel) :

```toml
[grammars.smarty]
repository = "https://github.com/iwlabdev-coder/tree-sitter-smarty"
rev = "32f1e0c8750a0638c6621bda6d4e1300f70b680b"
```

L'extension devient alors autonome : un seul `install dev extension`, Zed
clone et compile la grammaire automatiquement. C'est aussi ce qu'il faudra
faire pour publier l'extension sur le registre Zed.

Réinstalle proprement (désinstaller puis réinstaller) après toute mise à jour ;
Zed doit recompiler les deux grammaires (Smarty forkée + php_only).

## Ce qui est désormais coloré

- Variables d'en-tête `{foreach $items as $k => $v}` → `@variable`.
- Tags `{assign var=… value=…}` et `{l s='…' d='…'}` : clés → `@property`,
  chaînes → `@string`, valeurs-expressions injectées en PHP.
- Échos `{$x}`, `{count(...)}`, conditions de `{if}` → PHP injecté
  (variables, fonctions, nombres, opérateurs distincts).
- Modificateurs `|escape` → `@function`, commentaires, accolades.

## Modifications de la grammaire (fork)

Par rapport à `Kibadda/tree-sitter-smarty` :
- variables d'en-tête de `{foreach}` exposées comme nœuds `(variable)` ;
- règles `{assign}` et `{l }` avec paramètres `clé=valeur` structurés ;
- valeurs : chaînes `(string)` et expressions `(php)` séparées ;
- chaînes gérant l'échappement `\'` / `\"` ;
- **auto_literal** : un `{` suivi d'un espace/saut de ligne est traité comme
  du texte littéral (comme dans PrestaShop), donc les accolades JS/CSS dans
  les blocs `<script>`/`<style>` ne sont plus prises pour des tags Smarty ;
- `|` autorisé dans le texte (chaînes JS type `"a,|,b"`) ;
- commentaires `{* … *}` multi-lignes contenant des `*` (en-têtes de licence
  PrestaShop) correctement gérés ;
- `grammar.js` modifié + `src/parser.c` régénéré (tree-sitter 0.22.6).

Pour publier au lieu d'utiliser `file://`, pousse le dossier `tree-sitter-smarty`
sur GitHub et remplace `repository`/`rev` dans `extension.toml` par l'URL + le
SHA du commit poussé.

## Couleurs

Elles viennent du thème (captures `@variable`, `@function`, `@string`,
`@number`, `@property`, `@keyword`, `@operator`). Pour les forcer :

```json
"theme_overrides": {
  "Nom De Ton Thème": {
    "syntax": {
      "variable": { "color": "#82aaff" },
      "function": { "color": "#c792ea" },
      "string":   { "color": "#c3e88d" },
      "number":   { "color": "#f78c6c" },
      "property": { "color": "#ffcb6b" }
    }
  }
}
```

## Limites restantes

- Notation pointée `$a.b` : `$a` coloré, `.b` peu/pas (PHP utilise `->`/`[]`).
- `{l }` est reconnu par le préfixe littéral `{l ` (avec espace), donc sans
  collision avec `{literal}` / `{ldelim}`.