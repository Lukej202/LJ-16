import sys
import unittest
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'assembler'))
from assembler import assemble, AssemblyError

class AssemblerTests(unittest.TestCase):
    def test_r_type_fields(self):
        words, _ = assemble('ADD R3, R1, R2\nADD R3, R1, CR')
        self.assertEqual(words, [0x1000 | (3 << 8) | (1 << 5) | (2 << 2), 0x1000 | (3 << 8) | (1 << 5) | 2])
    def test_constant_halves(self):
        words, _ = assemble('LDCL 0xCD\nLDCH 0xAB')
        self.assertEqual(words, [0x58CD, 0x60AB])
    def test_label_resolution(self):
        words, labels = assemble('LDCL END\nLDCH END\nJMP CR\nEND: HALT')
        self.assertEqual(labels['END'], 3)
        self.assertEqual(words, [0x5803, 0x6000, 0x7802, 0x0800])
    def test_countdown(self):
        example = (Path(__file__).resolve().parents[1] / 'programs' / 'countdown.asm').read_text()
        words, labels = assemble(example)
        self.assertEqual(len(words), 11)
        self.assertEqual(labels['LOOP'], 8)
        self.assertEqual(words[-1], 0x0800)
    def test_rejects_bad_register(self):
        with self.assertRaises(AssemblyError):
            assemble('ADD R8, R1, R2')
    def test_rejects_oversize_immediate(self):
        with self.assertRaises(AssemblyError):
            assemble('LDCL 500')

if __name__ == '__main__':
    unittest.main()
