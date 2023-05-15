/// Representasi simpul dalam Trie
class TrieNode {
  /// Anak dari simpul Trie ini, dipetakan berdasarkan karakter mereka
  Map<String, TrieNode> child = {};

  /// Link ke simpul lain dalam Trie yang mewakili akhiran terpanjang dari string yang diasosiasikan dengan simpul ini
  TrieNode? suffixLink;

  /// Link ke simpul lain dalam Trie yang mewakili akhiran terpanjang dari string yang diasosiasikan dengan simpul ini, dan juga merupakan akhir dari beberapa pola
  TrieNode? outputLink;

  /// Indeks pola yang diasosiasikan dengan simpul ini (jika ada)
  int patternInd = -1;
}

/// Implementasi algoritma Aho-Corasick
class AhoCorasick {
  /// Akar dari Trie
  TrieNode root = TrieNode();

  /// Membangun Trie dari daftar pola
  void buildTrie(List<String> patterns) {
    for (int i = 0; i < patterns.length; i++) {
      TrieNode cur = root;
      for (String char in patterns[i].split('')) {
        if (cur.child.containsKey(char)) {
          cur = cur.child[char]!;
        } else {
          TrieNode newChild = TrieNode();
          cur.child[char] = newChild;
          cur = newChild;
        }
      }
      cur.patternInd = i;

      /// Menetapkan indeks pola untuk simpul ini
    }
  }

  /// Membangun link akhiran dan keluaran untuk setiap simpul dalam Trie
  void buildSuffixAndOutputLinks() {
    root.suffixLink = root;

    List<TrieNode> queue = [];
    for (TrieNode node in root.child.values) {
      queue.add(node);
      node.suffixLink = root;
    }

    while (queue.isNotEmpty) {
      TrieNode curState = queue.removeAt(0);

      for (String char in curState.child.keys) {
        TrieNode temp = curState.suffixLink!;
        while (!temp.child.containsKey(char) && temp != root) {
          temp = temp.suffixLink!;
        }
        if (temp.child.containsKey(char)) {
          curState.child[char]!.suffixLink = temp.child[char];
        } else {
          curState.child[char]!.suffixLink = root;
        }
        queue.add(curState.child[char]!);
      }

      if (curState.suffixLink!.patternInd >= 0) {
        curState.outputLink = curState.suffixLink;
      } else {
        curState.outputLink = curState.suffixLink!.outputLink;
      }
    }
  }

  /// Mencari pola dalam teks dan memperbarui daftar indeks dengan posisi di mana setiap pola ditemukan
  void searchPattern(String text, List<List<int>> indices) {
    TrieNode parent = root;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (parent.child.containsKey(char)) {
        parent = parent.child[char]!;

        if (parent.patternInd >= 0) {
          indices[parent.patternInd].add(i);
        }

        TrieNode? temp = parent.outputLink;
        while (temp != null) {
          indices[temp.patternInd].add(i);
          temp = temp.outputLink;
        }
      } else {
        while (parent != root && !parent.child.containsKey(char)) {
          parent = parent.suffixLink!;
        }

        /// Jika anak simpul yang sesuai ditemukan, mundur satu langkah dalam teks
        if (parent.child.containsKey(char)) {
          i--;
        }
      }
    }
  }
}
