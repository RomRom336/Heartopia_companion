import { createClient } from '@/utils/supabase/server'
import { TrackerView } from '@/components/tracker/TrackerView'
import { BirdFilters } from '@/components/tracker/BirdFilters'
import { birdToTrackerItem } from '@/types/database.types'
import type { DbBird } from '@/types/database.types'
import fs from 'fs'
import path from 'path'

// ── DEBUG TEMPORAIRE : compare images locales ↔ DB ───────────
function debugImageVsDb(dbNames: string[], folder: string) {
  const dir = path.join(process.cwd(), 'public', folder)
  const imageNames = fs.readdirSync(dir)
    .filter(f => f.endsWith('.webp'))
    .map(f => f.replace('.webp', ''))

  const dbSet    = new Set(dbNames)
  const imageSet = new Set(imageNames)

  const imagesWithoutDb = imageNames.filter(n => !dbSet.has(n))
  const dbWithoutImage  = dbNames.filter(n => !imageSet.has(n))

  console.log('\n══════════════════════════════════════════')
  console.log(`🐦 DEBUG ${folder.toUpperCase()} — images vs DB`)
  console.log('══════════════════════════════════════════')
  console.log(`📁 Images : ${imageNames.length} | 🗄️  DB : ${dbNames.length}`)
  if (imagesWithoutDb.length) {
    console.log(`\n❌ Images sans entrée DB (${imagesWithoutDb.length}) :`)
    imagesWithoutDb.forEach(n => console.log(`   • ${n}`))
  } else {
    console.log('\n✅ Toutes les images ont une entrée DB')
  }
  if (dbWithoutImage.length) {
    console.log(`\n⚠️  Entrées DB sans image (${dbWithoutImage.length}) :`)
    dbWithoutImage.forEach(n => console.log(`   • ${n}`))
  } else {
    console.log('✅ Toutes les entrées DB ont une image')
  }
  console.log('══════════════════════════════════════════\n')
}
// ── FIN DEBUG ─────────────────────────────────────────────────

export default async function BirdTrackerPage() {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('bird')
    .select('*')
    .order('passion_level', { ascending: true })
    .order('name', { ascending: true })

  if (error) console.error('Bird fetch error:', error)

  const items = ((data ?? []) as DbBird[]).map(birdToTrackerItem)

  debugImageVsDb(items.map(i => i.name_en), 'birds')

  const locations = Array.from(
    new Set(items.map(i => i.exact_location).filter(Boolean)),
  ).sort() as string[]

  return (
    <TrackerView
      items={items}
      category="Oiseaux"
      title="Oiseaux"
      specificFilters={<BirdFilters locations={locations} />}
    />
  )
}
